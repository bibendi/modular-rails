# frozen_string_literal: true

module CoreBy
  class NotifySubscriptionsJob < Base::Job
    def perform(name, payload, object)
      ApplicationSchema
        .subscriptions
        .trigger(name, payload, object)
    end
  end
end
