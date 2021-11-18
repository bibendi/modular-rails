# frozen_string_literal: true

module CoreBy
  module Users
    class Discard < Base::Service
      param :user

      def call
        return if user.discarded?

        user.transaction do
          user.discard!

          Downstream.publish(Events::Users::Discarded.new(user: user))
        end
      end
    end
  end
end
