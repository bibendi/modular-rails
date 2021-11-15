# frozen_string_literal: true

return unless defined?(Yabeda)

ActiveSupport.on_load("core_by/application_schema") do
  use Yabeda::GraphQL
end
