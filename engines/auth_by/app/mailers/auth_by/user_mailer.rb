# frozen_string_literal: true

module AuthBy
  class UserMailer < CoreBy::Base::Mailer
    def reset_password_instructions(token)
      @reset_password_token = token

      mail(
        to: user.email,
        subject: "Reset password instructions"
      )
    end
  end
end
