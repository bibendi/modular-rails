# frozen_string_literal: true

ActiveSupport.on_load("core_by/sdk/application_controller") do
  include AuthBy::Ext::CoreBy::SDK::ApplicationController
end

ActiveSupport.on_load("core_by/sdk/api_controller") do
  include AuthBy::Ext::CoreBy::SDK::APIController
end

ActiveSupport.on_load("core_by/sdk/cable_connection") do
  include AuthBy::Ext::CoreBy::SDK::CableConnection
end

ActiveSupport.on_load("core_by/mutation_root") do
  include AuthBy::MutationRoot
end
