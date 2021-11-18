# frozen_string_literal: true

require "rails"
require "active_storage"
require "action_cable"
require "action_policy"
require "activerecord/postgres_enum"
require "after_commit_everywhere"
require "imgproxy"
require "activejob-status"
require "active_job/uniqueness"
require "downstream"
require "common/factory"
require "phonelib"
require "redis-mutex"
require "schked"
require "database_validations"
require "discard"
require "dry/initializer"
require "name_of_person"
require "nanoid"
require "anycable-rails"
require "rails-i18n"
require "paper_trail"
require "graphql"
require "action_policy/graphql"
require "graphql-anycable"
require "graphql-fragment_cache"
require "graphql/persisted_queries"
require "graphql/connections"
require "resonad"

require "active_record/types/stripped_string"
require "core_by/active_storage"
require "core_by/statistics"
require "core_by/graphql/loaders/association_loader"
require "core_by/graphql/loaders/record_loader"

module CoreBy
  class << self
    def table_name_prefix
      ""
    end
  end
end

require "core_by/engine"
