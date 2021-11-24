# frozen_string_literal: true

module CoreBy
  module Users
    class BaseForm < SDK::ApplicationForm
      attr_reader :user

      validate :validate_user

      def initialize(user, params)
        @user = user

        user.assign_attributes(params)
      end

      def persist!
        user.save!
      rescue ActiveRecord::RecordNotUnique
        errors.add(:base, "User already exists")
        false
      end

      private

      def validate_user
        return if user.valid?

        merge_errors!(user)
      end
    end
  end
end
