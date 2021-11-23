# frozen_string_literal: true

ActiveSupport.on_load("core_by/query_root") do
  include Interests::QueryRoot
end

ActiveSupport.on_load("core_by/mutation_root") do
  include Interests::MutationRoot
end

ActiveSupport.on_load("core_by/sdk/types/user") do
  include Interests::Types::Ext::User
end
