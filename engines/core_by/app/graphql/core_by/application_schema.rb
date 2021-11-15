# frozen_string_literal: true

module CoreBy
  class ApplicationSchema < ::GraphQL::Schema
    use ::GraphQL::Dataloader
    use ::GraphQL::FragmentCache
    use ::GraphQL::PersistedQueries, compiled_queries: true

    max_depth 13
    max_complexity 200
    default_max_page_size 10

    case ActionCable.server.config.cable&.fetch("adapter", nil)
    when "redis"
      use ::GraphQL::Subscriptions::ActionCableSubscriptions, broadcast: true, default_broadcastable: true
    when "any_cable"
      use ::GraphQL::AnyCable, broadcast: true, default_broadcastable: true
    end

    query QueryRoot
    mutation MutationRoot
    subscription SubscriptionRoot if SubscriptionRoot.fields.any? # We don't have any subscriptions in this engine

    rescue_from(ActiveRecord::RecordNotFound) do |err|
      reason = err.model.underscore if err.respond_to?(:model) && err.model.present?
      raise GraphQL::ExecutionError.new("Not found", extensions: {code: :not_found, reason: reason})
    end

    rescue_from(::ActiveStorage::FileNotFoundError) do |err|
      reason = "Attachment file was not found on server"
      raise GraphQL::ExecutionError.new("File not found", extensions: {code: :not_found, reason: reason})
    end

    rescue_from(ActionPolicy::Unauthorized) do |exp|
      if exp.result.message == "Not found"
        raise ::GraphQL::ExecutionError.new("Not found", extensions: {code: :not_found})
      end

      raise ::GraphQL::ExecutionError.new(
        exp.result.message,
        extensions: {
          code: :unauthorized,
          fullMessages: exp.result.reasons.full_messages,
          details: exp.result.reasons.details
        }
      )
    end
  end

  ActiveSupport.run_load_hooks("core_by/application_schema", ApplicationSchema)
end
