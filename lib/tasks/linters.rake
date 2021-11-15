# frozen_string_literal: true

namespace :db do
  desc "Checks that database constraints present for `belongs_to` assocaitions " \
       "and uniqueness validations"
  task :validate_integrity do
    # Enable check (it's disable in development/test env by default)
    ENV["DB_VALIDATE_INTEGRITY"] = "1"

    # Ensure code is eager loaded
    ENV["EAGER_LOAD"] = "1"

    begin
      require_relative "../../config/environment"
      $stdout.puts "✅  DB integrity is OK"
    rescue DatabaseValidations::Errors::Base => e
      abort "💥 DB integrity is broken: #{e.message}"
    end
  end

  desc "Perform database_consistency check"
  task :consistency_check do
    # Ensure code is eager loaded
    ENV["EAGER_LOAD"] = "1"
    ENV["COLOR"] = "1"

    require_relative "../../config/environment"
    require "database_consistency"

    if DatabaseConsistency.run > 0
      abort "💥 DB consistency is broken"
    end
  end
end
