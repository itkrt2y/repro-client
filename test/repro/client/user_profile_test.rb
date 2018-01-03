require "test_helper"

class Repro::Client::UserProfileTest < Minitest::Spec
  let(:client) { Repro::Client.new("token") }
  let(:user_id) { "user-1" }
  let(:user_profiles) { [{ key: "Job", type: "string", value: "Developer" }] }
  let(:too_many_requests) { false }

  describe "#update_user_profiles" do
    include StubConnection

    subject do
      user_profile_client_stub(client, user_id, user_profiles, too_many_requests) { client.update_user_profiles(user_id, user_profiles) }
    end

    it "returns accepted" do
      expected = {"user_id"=>"user-1", "user_profiles"=>[{"key"=>"Job", "type"=>"string", "value"=>"Developer"}]}
      assert_equal 202, subject.status
      assert_equal expected, subject.body
    end

    describe "with invalid user_profiles" do
      let(:user_profiles) { [{ key: "Job", type: "string", value: 1 }] }
      it do
        assert_raises Repro::InvalidUserProfile do
          subject
        end
      end
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

    describe "too many requests" do
      let(:too_many_requests) { true }
      it {
        assert_raises Repro::TooManyRequests do
          subject
        end
      }
    end
  end

  describe "#user_profile_endpoint" do
    it { assert_equal "https://api.repro.io/v2/user_profiles", client.user_profile_endpoint }
  end

  describe "#user_profile_path" do
    it { assert_equal "", client.user_profile_path }
  end

  describe "#user_profile_payload" do
    it do
      assert_equal(
        { user_id: user_id, user_profiles: user_profiles },
        client.user_profile_payload(user_id, user_profiles)
      )
    end
  end

end
