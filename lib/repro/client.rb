# frozen_string_literal: true

require "repro/connection"
require "repro/client/push"
require "repro/client/user_profile"
require "repro/response/rate_limit"

module Repro
  class Client
    include Repro::Connection
    include Repro::Client::Push
    include Repro::Client::UserProfile

    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def rate_limit
      Repro::Response::RateLimit.from_response(last_response)
    end

    def retry_after
      last_response && last_response.headers["Retry-After"]
    end
  end
end
