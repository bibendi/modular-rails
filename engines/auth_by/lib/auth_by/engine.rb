# frozen_string_literal: true

require "rails/engine"

module AuthBy
  class << self
    def configure
      yield Engine.config
    end
  end

  class Engine < ::Rails::Engine
    isolate_namespace AuthBy

    config.autoload_paths += Dir["#{config.root}/app/**/concerns"]
    config.autoload_paths += Dir["#{config.root}/public/*"]

    initializer "auth_by" do |app|
      app.config.paths["db/migrate"].concat(config.paths["db/migrate"].expanded)

      # For migration_context (used for checking pending migrations)
      ActiveRecord::Migrator.migrations_paths += config.paths["db/migrate"].expanded.flatten

      engine_factories_path = root.join("spec", "factories")

      ActiveSupport.on_load(:factory_bot) do
        FactoryBot.definition_file_paths.unshift engine_factories_path
      end
    end

    initializer "auth_by.subscribers" do |_app|
      ActiveSupport.on_load "downstream-events" do |store|
        store.subscribe(CoreBy::SDK::Users::OnDiscarded::FlushSessions, async: true)
      end
    end
  end
end
