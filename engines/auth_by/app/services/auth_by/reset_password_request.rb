# frozen_string_literal: true

module AuthBy
  class ResetPasswordRequest < CoreBy::BaseService
    param :user

    def call
      user.generate_reset_password_token!
      deliver_reset_password_instructions
    end

    def deliver_reset_password_instructions
      UserMailer
        .with(user: user)
        .reset_password_instructions(user.reset_password_token)
        .deliver_later
    end
  end
end
