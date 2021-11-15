# frozen_string_literal: true

Rake::Task.define_task(
  "assets:precompile" => [
    "database_validations:skip_db_uniqueness_validator_index_check",
    "graphdoc:dump_schema",
    "graphdoc:generate"
  ]
)
