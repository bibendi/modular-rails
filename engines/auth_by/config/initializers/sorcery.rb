# frozen_string_literal: true

# Sorcery configuration
# Source https://github.com/Sorcery/sorcery/blob/master/lib/generators/sorcery/templates/initializer.rb

Rails.application.config.sorcery.submodules = [:remember_me, :reset_password, :brute_force_protection]

Rails.application.config.sorcery.configure do |config|
  # --- user config ---
  config.user_config do |user|
    user.stretches = 1 if Rails.env.test? # rubocop:disable Lint/Env
    # -- remember_me --
    #
    # How long in seconds the session length will be
    # Default: `604800`
    #
    user.remember_me_for = 30.days
    #
    # When true sorcery will persist a single remember me token for all
    # logins/logouts (supporting remembering on multiple browsers simultaneously).
    # Default: false
    #
    user.remember_me_token_persist_globally = true
    #
    # -- reset_password
    #
    # We do not use built-in mailer
    #
    user.reset_password_mailer_disabled = true
    #
    # This field is populated when token is generated, not email sent
    #
    user.reset_password_email_sent_at_attribute_name = :reset_password_token_generated_at

    # How many failed logins are allowed
    user.consecutive_login_retries_amount_limit = 10

    # How long the user should be banned, in seconds. 0 for permanent.
    user.login_lock_time_period = 10.minutes
  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = "AuthBy::User"
end
