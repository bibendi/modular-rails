# frozen_string_literal: true

require "rails_helper"

describe SMTPConfig, type: :config do
  subject { described_class.new }

  describe "#to_settings" do
    specify do
      with_env(
        "SMTP_ADDRESS" => "smtp.mailgun.org",
        "SMTP_DOMAIN" => "mail.example.com",
        "SMTP_USERNAME" => "sender@example.com",
        "SMTP_PASSWORD" => "postman-secret"
      ) do
        expect(subject.to_settings).to eq(
          {
            address: "smtp.mailgun.org",
            domain: "mail.example.com",
            user_name: "sender@example.com",
            password: "postman-secret",
            # defaults
            authentication: :plain,
            port: 587
          }
        )
      end
    end
  end
end
