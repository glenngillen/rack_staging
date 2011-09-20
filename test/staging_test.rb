$:.unshift(File.expand_path(File.dirname(__FILE__)))
require "test_helper"

class DummyApp

  def call(env)
    [ 200, {'Content-Type' => 'text/plain'}, ['this is from DummyApp'] ]
  end
end

class RackStagingTest < Test::Unit::TestCase

  def app
    @app ||= Rack::Builder.new do
      use Rack::Staging
      run DummyApp.new
    end
  end

  def test_passes_through_to_other_middleware_if_not_staging
    get "/"
    assert_equal 200, last_response.status
    assert_equal "this is from DummyApp", last_response.body
  end

  def test_robots_txt_if_staging
    header "Host", "staging.example.org"
    get "/robots.txt"
    expected = <<-EOF
User-agent: *
Disallow: /
EOF
    assert_equal expected, last_response.body
  end

  def test_requires_authentication_if_staging
    header "Host", "staging.example.org"
    get "/"
    assert_equal 401, last_response.status
  end

  def test_requires_authentication_if_env_var_set
    ENV["STAGING"] = "true"
    get "/"
    assert_equal 401, last_response.status
  ensure
    ENV.delete("STAGING")
  end

  def test_requires_authentication_if_proc_returns_true
    @app = Rack::Builder.new do
      use Rack::Staging, Proc.new{|env| env["HTTP_HOST"] =~ /foobar/ }
      run DummyApp.new
    end
    header "Host", "staging.example.org"
    get "/"
    assert_equal 200, last_response.status

    header "Host", "foobar.org"
    get "/"
    assert_equal 401, last_response.status
  end

  def test_auths_based_on_env_settings
    ENV["STAGING_USER"] = "top"
    ENV["STAGING_PASS"] = "seecrets"

    header "Host", "staging.example.org"
    get "/"
    assert_equal 401, last_response.status
    authorize "top", "seecrets"
    get "/"
    assert_equal 200, last_response.status
  ensure
    ENV.delete("STAGING_USER")
    ENV.delete("STAGING_PASS")
  end
end
