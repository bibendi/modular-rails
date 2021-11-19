# frozen_string_literal: true

module CoreBy
  module Events
    module Users
      module OnDiscarded
        module FlushSessions
          def self.call(payload)
            user = payload.user

            AuthBy::User.find(user.id).flush_jwt_tokens
          end
        end
      end
    end
  end
end
