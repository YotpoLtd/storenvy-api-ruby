require 'typhoeus/adapters/faraday'
require 'faraday_middleware/response_middleware'

module Storenvy
  class ResponseParser < Faraday::Response::Middleware
    def call(env)
      # "env" contains the request
      @app.call(env).on_complete do
        body = false
        if env[:status] >= 200 || env[:status] < 300
          body = env[:response].body.response || env[:response].body
        elsif env[:status] == 401
          raise HTTPUnauthorized.new 'invalid storeenvy credentials'
        elsif env[:response] && env[:response].body && env[:response].body.status
          body = env[:response].body.status
        end
        env[:body] = body
      end
    end
    class HTTPUnauthorized < Exception
    end
  end
end