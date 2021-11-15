# frozen_string_literal: true

require "rails"
require "core_by/engine"
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
