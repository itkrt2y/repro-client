# frozen_string_literal: true

module Repro
  class Response
    attr_reader :status, :body

    def initialize(response)
      @status = response.status
      @body = JSON.parse(response.body)
    end
  end
end
