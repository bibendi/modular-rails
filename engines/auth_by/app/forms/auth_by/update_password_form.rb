# frozen_string_literal: true

module AuthBy
  class UpdatePasswordForm < CoreBy::Base::Form
    attributes :user, :current_password, :password, :password_confirmation

    validates :current_password, presence: true
    validates :password, length: {minimum: 8}, confirmation: true
    validate :validate_current_password

    def persist!
      user.change_password!(password)
    end

    private

    def validate_current_password
      errors.add(:current_password, :invalid) unless user.valid_password?(current_password)
    end
  end
end
