# frozen_string_literal: true

# TODO: Make PR to Combustion gem.
Combustion::Database::Migrate.prepend(Module.new do
  def call
    migration_contexts do |context|
      context.migrate
    end
  end

  def migration_contexts
    primary_config = nil

    ActiveRecord::Base.configurations.configs_for(env_name: "test").each do |db_config|
      primary_config = db_config.configuration_hash if db_config.name == "primary"

      ActiveRecord::Base.establish_connection(db_config.configuration_hash)

      yield ActiveRecord::MigrationContext.new(
        engine_migration_paths(db_config.name),
        ActiveRecord::Base.connection.schema_migration
      )
    end

    ActiveRecord::Base.establish_connection(primary_config)
  end

  def engine_migration_paths(db_name)
    key = db_name.to_s == "primary" ? "" : "#{db_name}_"
    Rails.application.paths["db/#{key}migrate"].to_a
  end
end)
