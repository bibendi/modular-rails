# frozen_string_literal: true

# Do not check DB integrity by default, use `rails db:validate_integrity` task instead
ENV["SKIP_DB_UNIQUENESS_VALIDATOR_INDEX_CHECK"] = "true" unless ENV["DB_VALIDATE_INTEGRITY"] == "1"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Test only two locales
  config.i18n.available_locales = [:en, :ru]

  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = ENV["EAGER_LOAD"] == "1"

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Logging in tests is useless (especially to file)
  # You can turn it on by setting `LOG=all` env variable or
  # `log: true` tag to your spec.
  # See https://test-prof.evilmartians.io/#/logging
  config.logger = Logger.new(nil)
  config.log_level = :fatal

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # We test previews to make sure that emails are rendered without exceptions
  config.action_mailer.show_previews = true

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Use test adapter for active job
  config.active_job.queue_adapter = :test
end
