# frozen_string_literal: true

module CoreBy
  class BaseService
    extend Dry::Initializer
    include AfterCommitEverywhere

    # See options at https://github.com/kenn/redis-mutex#usage
    DEFAULT_MUTEX_OPTIONS = {block: 0, expire: 600}.freeze

    delegate :locked?, to: :mutex

    def self.call(...)
      new(...).call
    end

    private

    def with_lock
      return unless mutex.lock

      yield
    ensure
      mutex.unlock
    end

    def mutex
      @mutex ||= RedisMutex.new(mutex_key, mutex_options)
    end

    def mutex_key
      raise ArgumentError, "Mutex key must be defined in child class"
    end

    def mutex_options
      DEFAULT_MUTEX_OPTIONS
    end
  end
end
