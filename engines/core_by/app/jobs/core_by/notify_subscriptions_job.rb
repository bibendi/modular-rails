# frozen_string_literal: true

module CoreBy
  class NotifySubscriptionsJob < BaseJob
    def perform(name, payload, object)
      ApplicationSchema
        .subscriptions
        .trigger(name, payload, object)
    end
  end
end
