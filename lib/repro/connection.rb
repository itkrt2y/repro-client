# frozen_string_literal: true

require "faraday"
require "json"
require "repro/error"
require "repro/response"

module Repro
  module Connection
    def post(endpoint, path, payload)
      @last_response = connection(endpoint).post do |request|
        request.url path
        request.body = JSON.generate(payload)
      end

      error = Repro::Error.from_response(last_response)
      error ? raise(error) : Repro::Response.new(last_response)
    end

    def last_response
      @last_response
    end

    private

      def connection(endpoint)
        @connection ||= {}
        @connection[endpoint] ||= Faraday.new(endpoint) do |faraday|
          faraday.headers["Content-Type"] = "application/json"
          faraday.headers["X-Repro-Token"] = token
          faraday.adapter Faraday.default_adapter
        end
      end
  end
end
