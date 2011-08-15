require 'test/unit'
require 'rack/test'
require 'rack/builder'
require "#{File.dirname(__FILE__)}/../lib/rack_staging"

module Test
  module Unit
    class TestCase
      include Rack::Test::Methods
    end
  end
end
