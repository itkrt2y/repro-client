# frozen_string_literal: true

module Repro
  class Error < StandardError
    def self.from_response(response)
      body = JSON.parse(response.body)

      klass =
        case response.status
        when 400;      error_for_400(body.dig("error", "code"))
        when 401;      Repro::Unauthorized
        when 403;      Repro::Forbidden
        when 404;      Repro::NotFound
        when 422;      Repro::UnprocessableEntity
        when 429;      Repro::TooManyRequests
        when 400..499; Repro::ClientError
        end

      klass&.new(body)
    end

    def initialize(response_body)
      error_message = response_body.dig("error", "messages")&.join("\n")
      error_message ? super(error_message) : super
    end

    def self.error_for_400(code)
      case code
      when 1001; Repro::InvalidPayload
      when 1002; Repro::NotRegisteredUser
      when 1003; Repro::InvalidUserProfile
      else; Repro::BadRequest
      end
    end
  end

  # 400-499
  class ClientError < Error; end

  # HTTP status code: 400
  class BadRequest < ClientError; end

  # HTTP status code: 400, error code: 1001
  class InvalidPayload < ClientError; end

  # HTTP status code: 400, error code: 1002
  class NotRegisteredUser < ClientError; end

  # HTTP status code: 400, error code: 1003
  class InvalidUserProfile < ClientError; end

  # HTTP status code: 401
  class Unauthorized < ClientError
    def to_s
      "Please set your Repro API Token by `Repro.token = <token>` before calling API"
    end
  end

  # HTTP status code: 403
  class Forbidden < ClientError; end

  # HTTP status code: 404
  class NotFound < ClientError; end

  # HTTP status code: 422
  class UnprocessableEntity < ClientError; end

  # HTTP status code: 429
  class TooManyRequests < ClientError; end
end
