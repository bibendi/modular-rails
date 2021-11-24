# frozen_string_literal: true

module CoreBy
  class NotifySubscriptionsJob < SDK::ApplicationJob
    def perform(name, payload, object)
      ApplicationSchema
        .subscriptions
        .trigger(name, payload, object)
    end
  end
end
