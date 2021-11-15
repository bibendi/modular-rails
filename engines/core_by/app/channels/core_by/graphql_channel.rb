# frozen_string_literal: true

module CoreBy
  class GraphQLChannel < BaseChannel
    delegate :cable, to: "ActionCable.server.config"

    def initialize(connection, identifier, params = {})
      case cable&.fetch("adapter", nil)
      when "redis"
        @subscription_ids = []
      when "any_cable"
        params["channelId"] = "graphql:#{connection.connection_id}"
      end

      super
    end

    def execute(data)
      result = execute_query(data)

      if (subscription_id = result.context[:subscription_id]) && cable&.fetch("adapter", nil) == "redis"
        @subscription_ids << subscription_id
      end

      transmit(result: result.to_h, more: result.subscription?, operation_name: data["operationName"])
    end

    def unsubscribed
      case cable&.fetch("adapter", nil)
      when "redis"
        @subscription_ids.each do |sid|
          ApplicationSchema.subscriptions.delete_subscription(sid)
        end
      when "any_cable"
        ApplicationSchema.subscriptions.delete_channel_subscriptions(params.fetch("channelId"))
      end
    end

    private

    def build_context(data)
      {
        extensions: ensure_hash(data["extensions"]),
        current_user: current_user,
        channel: self
      }
    end

    def execute_query(data)
      ApplicationSchema.execute({
        query: data["query"],
        context: build_context(data),
        variables: ensure_hash(data["variables"]),
        operation_name: data["operationName"]
      })
    end

    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end
  end
end
