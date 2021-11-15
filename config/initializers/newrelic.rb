# frozen_string_literal: true

if defined?(NewRelic)
  ActiveSupport.on_load("core_by/application_schema") do
    use(GraphQL::Tracing::NewRelicTracing, set_transaction_name: true)
  end
end
