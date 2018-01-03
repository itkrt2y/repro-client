$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "repro/client"

require "minitest/autorun"

module StubConnection
  def push_client_stub(client, push_id, payload, too_many_requests, &block)
    status, body =
      if client.token.nil?
        [401, { status: "unauthorized", error: { messages: [ 'Please include your Repro API Token as "X-Repro-Token" HTTP header.' ] } }]
      elsif client.token == "invalid"
        [403, { status: "forbidden", error: { messages: [ 'Please check your Repro API Token as "X-Repro-Token" HTTP header.' ] } }]
      elsif push_id == "invalid"
        [404, { status: "not_found", error: { messages: [ "Not found." ] } }]
      elsif payload.empty?
        [422, { status: "unprocessable_entity", error: { messages: [ "notification must not be neigher null nor an empty hash" ] } }]
      elsif payload.none?{ |k, _| [:message, :custom_payload].include?(k) }
        [422, { status: "unprocessable_entity", error: { messages: [ "message, custom_payload are missing, exactly one parameter must be provided" ] } }]
      elsif too_many_requests
        [429, { status: "too_many_requests", error: { messages: [ "Too many requests hit the API too quickly." ] } }]
      else
        [202, { status: "accepted" }]
      end

    client_stub(client, client.push_path(push_id), status, body, &block)
  end

  def user_profile_client_stub(client, user_id, user_profiles, too_many_requests, &block)
    status, body =
      if user_id == "invalid"
        [400, { error: { code: 1002, messages: [ "'user-123' is not registered" ] } }]
      elsif user_profiles[0][:type] == "string" && !user_profiles[0][:value].is_a?(String)
        [400, { error: { code: 1003, messages: [ "Job does not have a valid value" ] } }]
      elsif client.token.nil?
        [401, { status: "unauthorized", error: { messages: [ 'Please include your Repro API Token as "X-Repro-Token" HTTP header.' ] } }]
      elsif client.token == "invalid"
        [403, { status: "forbidden", error: { messages: [ 'Please check your Repro API Token as "X-Repro-Token" HTTP header.' ] } }]
      elsif too_many_requests
        [429, { status: "too_many_requests", error: { messages: [ "Too many requests hit the API too quickly." ] } }]
      else
        [202, { user_id: user_id, user_profiles: user_profiles }]
      end

    client_stub(client, client.user_profile_path, status, body, &block)
  end

  private

    def client_stub(client, path, status, body, &block)
      connection = Faraday.new do|f|
        f.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post(path) { |_| [status, {}, JSON.generate(body)] }
        end
      end

      client.stub(:connection, connection, &block)
    end
end
