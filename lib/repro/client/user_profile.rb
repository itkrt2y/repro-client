# frozen_string_literal: true

module Repro
  class Client
    module UserProfile
      def update_user_profiles(user_id, user_profiles)
        post(user_profile_endpoint, user_profile_path, user_profile_payload(user_id, user_profiles))
      end

      def user_profile_endpoint
        "https://api.repro.io/v2/user_profiles"
      end

      def user_profile_path
        ""
      end

      def user_profile_payload(user_id, user_profiles)
        { user_id: user_id, user_profiles: user_profiles }
      end
    end
  end
end
