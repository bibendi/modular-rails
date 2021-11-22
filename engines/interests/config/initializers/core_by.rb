# frozen_string_literal: true

ActiveSupport.on_load("core_by/application_schema/query_root") do
  include Interests::QueryRoot
end

ActiveSupport.on_load("core_by/application_schema/mutation_root") do
  include Interests::MutationRoot
end

ActiveSupport.on_load("core_by/types/user") do
  include Interests::Types::Ext::User
end
