# frozen_string_literal: true

module AuthBy
  class ResetPasswordForm < CoreBy::Base::Form
    attributes :user, :password, :password_confirmation

    validates :password, length: {minimum: 8}, confirmation: true

    def persist!
      user.change_password!(password)
    end
  end
end
