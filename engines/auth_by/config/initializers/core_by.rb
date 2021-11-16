# frozen_string_literal: true

ActiveSupport.on_load("core_by/base_controller") do
  include AuthBy::BaseController
end

ActiveSupport.on_load("core_by/api/base_controller") do
  include AuthBy::Api::BaseController
end

ActiveSupport.on_load("core_by/application_schema/mutation_root") do
  include AuthBy::MutationRoot
end

ActiveSupport.on_load("core_by/cable_connection") do
  include AuthBy::CableConnection
end
