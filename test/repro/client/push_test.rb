require "test_helper"

class Repro::Client::PushTest < Minitest::Spec
  let(:client) { Repro::Client.new("token") }

  describe "#push" do
    include StubConnection

    let(:push_id) { "push-1" }
    let(:user_ids) { ["user-1"] }
    let(:payload) { { message: "Hello" } }
    let(:too_many_requests) { false }

    subject do
      push_client_stub(client, push_id, payload, too_many_requests ) {
        client.push(push_id, user_ids, payload)
      }
    end

    it "returns accepted" do
      assert_equal 202, subject.status
      assert_equal "accepted", subject.body["status"]
    end

    describe "without Repro API Token" do
      let(:client) { Repro::Client.new(nil) }
      it {
        assert_raises Repro::Unauthorized do
          subject
        end
      }
    end

    describe "with invalid Repro API Token" do
      let(:client) { Repro::Client.new("invalid") }
      it {
        assert_raises Repro::Forbidden do
          subject
        end
      }
    end

    describe "with invalid push_id" do
      let(:push_id) { "invalid" }
      it {
        assert_raises Repro::NotFound do
          subject
        end
      }
    end

    describe "with empty payload" do
      let(:payload) { {} }
      it {
        assert_raises Repro::UnprocessableEntity do
          subject
        end
      }
    end

    describe "with payload not including message or custom_payload" do
      let(:payload) { { deeplink_url: "http://sample.com", sound: "sound" } }
      it {
        assert_raises Repro::UnprocessableEntity do
          subject
        end
      }
    end

    describe "too many requests" do
      let(:too_many_requests) { true }
      it {
        assert_raises Repro::TooManyRequests do
          subject
        end
      }
    end
  end

  describe "#push_endpoint" do
    it { assert_equal "https://marketing.repro.io", client.push_endpoint }
  end

  describe "#push_path" do
    let(:push_id) { "abc123" }
    it { assert_equal "/v1/push/#{push_id}/deliver", client.push_path(push_id) }
  end

  describe "#push_payload" do
    let(:user_ids) { ["user-1", "user-2"] }

    describe "with custom_payload" do
      let(:custom_payload) { { foo: "bar" } }
      let(:expected) do
        {
          audience: { user_ids: user_ids },
          notification: { custom_payload: custom_payload }
        }
      end

      it { assert_equal expected, client.push_payload(user_ids, custom_payload: custom_payload) }

      it "ignores args except custom_payload" do
        assert_equal expected, client.push_payload(user_ids, custom_payload: custom_payload, message: "Hello")
      end
    end

    describe "without custom_payload" do
      it do
        assert_equal(
          { audience: { user_ids: user_ids }, notification: { message: "Hello" } },
          client.push_payload(user_ids, message: "Hello")
        )

        assert_equal(
          { audience: { user_ids: user_ids }, notification: { message: "Hello", deeplink_url: "deeplink url", sound: "sound" } },
          client.push_payload(user_ids, message: "Hello", deeplink_url: "deeplink url", sound: "sound")
        )
      end
    end
  end

end
