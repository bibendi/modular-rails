# frozen_string_literal: true

require "rails_helper"

describe AuthBy::ResetPasswordRequest do
  let_it_be(:user, reload: true) { create :auth_user }

  subject { described_class.call(user) }

  it "generates token" do
    expect { subject }.to change { user.reload.reset_password_token }.from(nil)
  end

  it "sends email" do
    expect { subject }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      .with(
        "AuthBy::UserMailer",
        "reset_password_instructions",
        "deliver_now",
        params: {user: user},
        args: [kind_of(String)]
      )
  end
end
