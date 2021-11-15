# frozen_string_literal: true

require_relative "boot"

# Make our lograge patches to have a higher priority
# Waiting for https://github.com/roidrage/lograge/pull/310
$LOAD_PATH.unshift(File.join(__dir__, "lograge_fix"))

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

%w[base app gcs imgproxy smtp sentry].each do |config_name|
  require_relative "./settings/#{config_name}_config"
end

module ModularRails
  class Application < Rails::Application
    # General project configuration
    config.app = AppConfig.instance

    # SMTP configuration
    config.smtp = SMTPConfig.instance

    # Imgproxy configuration
    config.imgproxy = ImgproxyConfig.instance

    # Sentry configuration
    config.sentry = SentryConfig.instance

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.add_autoload_paths_to_load_path = false

    # Custom not Rails-specific code
    config.autoload_paths << Rails.root.join("lib/ext")

    # Localization settings
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :ru]
    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation cannot be found).
    config.i18n.fallbacks = true

    # Time zone
    config.time_zone = "UTC"

    # Do not modify empty params. See https://github.com/rmosolgo/graphql-ruby/issues/986
    config.action_dispatch.perform_deep_munge = false

    config.action_dispatch.rescue_responses["ActionPolicy::Unauthorized"] = :forbidden

    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "DENY",
      "X-XSS-Protection" => "1; mode=block",
      "X-Content-Type-Options" => "nosniff"
    }

    # ActiveJob
    config.active_job.queue_adapter = :sidekiq

    # ActionMailer
    config.action_mailer.preview_path = Rails.root.join("engines/*/spec/mailers/previews")

    # ActionCable
    config.action_cable.url = config.app.cable_url.presence
    config.action_cable.disable_request_forgery_protection = true

    # ActiveStorage
    config.active_storage.service = config.app.active_storage_service.to_sym
    config.active_storage.service_urls_expire_in = 1.month
    config.active_storage.disk_endpoint = config.app.endpoint
    config.active_storage.disk_internal_endpoint = config.app.active_storage_disk_internal_endpoint
    config.active_storage.analyzers = []

    # Lograge
    config.lograge.enabled = true

    # Load locales from subfolders
    config.i18n.load_path += Dir[
      Rails.root.join("config", "locales", "**", "*.{yml,rb}").to_s
    ]

    # Configure generators
    config.generators do |g|
      g.assets false
      g.javascripts false
      g.stylesheets false
      g.helper false
      g.system_tests false

      g.orm :active_record
      g.test_framework :rspec,
        fixtures: false, # we do not generate factories in the root app
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: true,
        controller_specs: true
    end

    # Defines whetehr to generate Graphdoc static website
    # in run time or not
    config.graphdoc_run_time = false
  end
end
