# frozen_string_literal: true

module Repro
  class Response
    class RateLimit < Struct.new(:limit, :remaining, :reset)
      def self.from_response(response)
        return unless response

        new.tap do |rate_limit|
          headers = response.headers
          rate_limit.limit     = headers["X-RateLimit-Limit"]
          rate_limit.remaining = headers["X-RateLimit-Remaining"]
          rate_limit.reset     = headers["X-RateLimit-Reset"]
        end
      end
    end
  end
end

