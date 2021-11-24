# frozen_string_literal: true

module CoreBy
  module Users
    class Discard < SDK::ApplicationService
      param :user

      def call
        return if user.discarded?

        user.transaction do
          user.discard!

          Downstream.publish(SDK::Users::Discarded.new(user: user))
        end
      end
    end
  end
end
