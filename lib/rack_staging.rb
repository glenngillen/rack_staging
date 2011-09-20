require 'rack'
module Rack
  class Staging < Rack::Auth::Basic
    def initialize(app, detect_proc = nil)
      @app = app

      @staging_detect = detect_proc || lambda do |env|
        env["HTTP_HOST"] =~ /staging/ || ENV["STAGING"]
      end

      super app, 'staging' do |username, password|
        [username, password] == [ENV["STAGING_USER"], ENV["STAGING_PASS"]]
      end 
    end
    
    def call(env)
      @env = env
      if @staging_detect.call(@env)
        return robots_txt if robots_txt?(env)
        super
      else
        @app.call(env)
      end
    end

    def robots_txt?(env)
      env["PATH_INFO"] == "/robots.txt"
    end

    def robots_txt
      body = <<-EOF
User-agent: *
Disallow: /
EOF
      [ 200, {'Content-Type' => 'text/plain'}, [body] ]
    end
  end
end
