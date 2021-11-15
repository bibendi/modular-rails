# frozen_string_literal: true

class SMTPConfig < BaseConfig
  attr_config :address, :domain, :username, :password,
    port: 587,
    authentication: :plain

  # See https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration
  def to_settings
    {
      address: address,
      authentication: authentication,
      domain: domain,
      password: password,
      port: port,
      user_name: username
    }
  end
end
