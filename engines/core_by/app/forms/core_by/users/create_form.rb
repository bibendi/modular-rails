# frozen_string_literal: true

module CoreBy
  module Users
    class CreateForm < BaseForm
      delegate :phone, to: :user
      validates :phone, presence: true

      after_save do
        Downstream.publish(
          CoreBy::Users::Created.new(user: user)
        )
      end

      def initialize(params)
        user = User.new(role: :member)
        super(user, params)
      end
    end
  end
end
