# frozen_string_literal: true

module CoreBy
  module Events
    module Users
      module OnDiscarded
        module FlushSessions
          def self.call(payload)
            user = payload.user

            user.becomes(AuthBy::User).flush_jwt_tokens
          end
        end
      end
    end
  end
end
