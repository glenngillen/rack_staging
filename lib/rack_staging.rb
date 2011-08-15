require 'rack'
module Rack
  class Staging

    def initialize(app, staging_test = nil)
      @app = app
      @staging_test = staging_test
    end

    def call(env)
      return @app.call(env) unless staging?(env)
      return robots_txt if robots_txt?(env)
      return unauthorized unless authorized?(env)
      @app.call(env)
    end

    private
      def staging?(env)
        return @staging_test.call(env) if @staging_test
        env["HTTP_HOST"] =~ /staging/ || ENV["STAGING"]
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

      def authorized?(env)
        @auth ||=  Rack::Auth::Basic::Request.new(env)
        @auth.provided? &&
          @auth.basic? &&
          @auth.credentials &&
          @auth.credentials == [ENV["STAGING_USER"], ENV["STAGING_PASS"]]
      end

      def unauthorized
        [ 401, {'Content-Type' => 'text/plain'}, ["Unauthorized"] ]
      end


  end
end
