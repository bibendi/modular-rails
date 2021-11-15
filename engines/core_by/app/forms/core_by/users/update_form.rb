# frozen_string_literal: true

module CoreBy
  module Users
    class UpdateForm < BaseForm
      delegate :login, to: :user
      validates :login, presence: true

      after_save do
        Downstream.publish(
          CoreBy::Users::Updated.new(
            user: user,
            changed_fields: user.saved_changes.keys
          )
        )
      end
    end
  end
end
