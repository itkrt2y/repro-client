# frozen_string_literal: true

module Repro
  class Error < StandardError
    def self.from_response(response)
      klass =
        case response.status
        when 400;      Repro::BadRequest
        when 401;      Repro::Unauthorized
        when 403;      Repro::Forbidden
        when 404;      Repro::NotFound
        when 422;      Repro::UnprocessableEntity
        when 429;      Repro::TooManyRequests
        when 400..499; Repro::ClientError
        end

      klass.new(response) if klass
    end

    def initialize(response)
      data = JSON.parse(response.body)
      error_message = data.dig("error", "messages")&.join("\n") || data["status"]
      super(error_message)
    end
  end

  # 400-499
  class ClientError < Error; end

  # HTTP status code: 400
  class BadRequest < ClientError; end

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
