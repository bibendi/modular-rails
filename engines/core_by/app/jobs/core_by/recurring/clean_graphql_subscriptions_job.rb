# frozen_string_literal: true

module CoreBy
  module Recurring
    # https://github.com/anycable/graphql-anycable#operations
    # https://github.com/anycable/graphql-anycable/blob/master/lib/graphql/anycable/tasks/clean_expired_subscriptions.rake
    class CleanGraphQLSubscriptionsJob < Base::RecurringJob
      queue_as :low_priority

      def perform
        with_lock do
          GraphQL::AnyCable::Cleaner.clean_channels
          GraphQL::AnyCable::Cleaner.clean_subscriptions
          GraphQL::AnyCable::Cleaner.clean_events
        end
      end
    end
  end
end
