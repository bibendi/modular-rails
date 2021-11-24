# frozen_string_literal: true

module CoreBy
  module SDK
    class RecurringJob < ApplicationJob
      private

      # See options at https://github.com/kenn/redis-mutex#usage
      DEFAULT_MUTEX_OPTIONS = {block: 0, expire: 600}.freeze

      def with_lock
        return unless mutex.lock

        yield
      ensure
        mutex.unlock
      end

      def mutex
        @mutex ||= ::RedisMutex.new(mutex_key, mutex_options)
      end

      def mutex_key
        self.class.name.underscore
      end

      def mutex_options
        DEFAULT_MUTEX_OPTIONS
      end
    end
  end
end
