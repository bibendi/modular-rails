# frozen_string_literal: true

module CoreBy
  module SDK
    class CableConnection < ActionCable::Connection::Base
      identified_by :current_user, :connection_id

      def connect
        reject_unauthorized_connection unless current_user

        self.connection_id = SecureRandom.uuid
      end
    end

    ActiveSupport.run_load_hooks("core_by/sdk/cable_connection", CableConnection)
  end
end
