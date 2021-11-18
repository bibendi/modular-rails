# frozen_string_literal: true

require "rails/engine"

module CoreBy
  class << self
    def configure
      yield Engine.config
    end
  end

  class Engine < ::Rails::Engine
    isolate_namespace CoreBy

    config.autoload_paths += Dir["#{config.root}/app/**/concerns"]

    config.core_by = ActiveSupport::OrderedOptions.new

    initializer "core_by" do |app|
      app.config.paths["db/migrate"].concat(config.paths["db/migrate"].expanded)
      app.config.paths["db/statistics_migrate"] ||= []
      app.config.paths["db/statistics_migrate"] << Engine.root.join("db/statistics_migrate")

      # For migration_context (used for checking pending migrations)
      ActiveRecord::Migrator.migrations_paths += config.paths["db/migrate"].expanded.flatten

      Schked.config.paths << root.join("config", "schedule.rb")

      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Type.register(:stripped_string, ActiveRecord::Types::StrippedString)
      end

      engine_factories_path = root.join("spec", "factories")

      ActiveSupport.on_load(:factory_bot) do
        FactoryBot.definition_file_paths.unshift engine_factories_path
      end
    end

    rake_tasks do
      load "core_by/tasks/graphql.rake"
    end
  end
end
