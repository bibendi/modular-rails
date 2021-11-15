# frozen_string_literal: true

module CoreBy
  module Users
    class Discard < BaseService
      param :user

      def call
        return if user.discarded?

        user.transaction do
          user.discard!

          Downstream.publish(Discarded.new(user: user))
        end
      end
    end
  end
end
