# frozen_string_literal: true

module AuthBy
  class UserMailerPreview < CoreBy::BaseMailerPreview
    def reset_password_instructions
      UserMailer
        .with(user: user)
        .reset_password_instructions(token: "some-reset-password-token")
    end
  end
end
