require "test_helper"

class Repro::ClientTest < Minitest::Spec
  it "has a version number" do
    refute_nil ::Repro::Client::VERSION
  end

  describe "with invalid token" do
    let(:response_body) do
      JSON.generate(
        {
          "status": "forbidden",
          "error": {
            "messages": [
              'Please check your Repro API Token as "X-Repro-Token" HTTP header.'
            ]
          }
        }
      )
    end

    let(:stub_connection) do
      Faraday.new do|f|
        f.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post("/v1/push/1/deliver") { |_| [403, {}, response_body] }
        end
      end
    end

    let(:client) { Repro::Client.new("token") }

    it "returns Forbidden" do
      assert_raises Repro::Forbidden do
        client.stub(:connection, stub_connection) do
          client.push("1", {})
        end
      end
    end
  end
end
