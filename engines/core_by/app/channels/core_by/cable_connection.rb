# frozen_string_literal: true

module CoreBy
  class CableConnection < ActionCable::Connection::Base
    identified_by :current_user, :connection_id

    def connect
      reject_unauthorized_connection unless current_user

      self.connection_id = SecureRandom.uuid
    end

    ActiveSupport.run_load_hooks("core_by/cable_connection", self)
  end
end
