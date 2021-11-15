# frozen_string_literal: true

module CoreBy
  class MailerConfig < Anyway::Config
    config_name :mailer

    attr_config :from, :reply_to
  end
end
