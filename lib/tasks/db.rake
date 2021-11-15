# frozen_string_literal: true

# TimescaleDB is not dumpable
Rake::Task["db:schema:load:statistics"]&.clear
Rake::Task["db:_dump:statistics"]&.clear
Rake::Task["db:schema:dump:statistics"]&.clear
Rake::Task["db:test:load_schema:statistics"]&.clear
Rake::Task["db:schema:dump"]&.clear

namespace :db do
  namespace :schema do
    # https://github.com/rails/rails/commit/10ca60a16b1bb7b51d32dfbf5913be96cbe9984e
    raise "Remove patch below in Rails 7" if Rails::VERSION::MAJOR == 7

    desc "Creates a database schema file (either db/schema.rb or db/structure.sql, depending on `config.active_record.schema_format`)"
    task dump: :load_config do
      ActiveRecord::Base.configurations.configs_for(env_name: ActiveRecord::Tasks::DatabaseTasks.env).each do |db_config|
        if db_config.configuration_hash.fetch(:schema_dump, true)
          ActiveRecord::Base.establish_connection(db_config)
          ActiveRecord::Tasks::DatabaseTasks.dump_schema(db_config)
        end
      end

      Rake::Task["db:schema:dump"].reenable
    end
  end

  desc "Reset database without running seeds"
  task recreate: ["db:drop", "db:create", "db:schema:load:primary", "db:migrate"]

  desc "Reset database without running seeds and using migrations instead of schema"
  task remigrate: ["db:drop", "db:create", "db:migrate"]
end
