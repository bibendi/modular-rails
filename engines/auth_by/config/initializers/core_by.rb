# frozen_string_literal: true

ActiveSupport.on_load("core_by/base/application_controller") do
  include AuthBy::Ext::CoreBy::Base::ApplicationController
end

ActiveSupport.on_load("core_by/base/api_controller") do
  include AuthBy::Ext::CoreBy::Base::ApiController
end

ActiveSupport.on_load("core_by/base/cable_connection") do
  include AuthBy::Ext::CoreBy::Base::CableConnection
end

ActiveSupport.on_load("core_by/application_schema/mutation_root") do
  include AuthBy::MutationRoot
end
