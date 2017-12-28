# frozen_string_literal: true

module Repro
  class Client
    module Push
      def push(push_id, user_ids, options={})
        post(push_endpoint , push_path(push_id), push_payload(user_ids, options))
      end

      def push_endpoint
        "https://marketing.repro.io"
      end

      def push_path(push_id)
        "/v1/push/#{push_id}/deliver"
      end

      def push_payload(user_ids, options={})
        {
          audience: { user_ids: user_ids },
          notification: notification(options)
        }
      end

      private

        def notification(message: nil, deeplink_url: nil, sound: nil, custom_payload: nil)
          if custom_payload
            { custom_payload: custom_payload }
          else
            { message: message, deeplink_url: deeplink_url, sound: sound }.compact
          end
        end
    end
  end
end
