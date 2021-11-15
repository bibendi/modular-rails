# frozen_string_literal: true

require "hiredis"

Redis.current = Redis.new(url: CoreBy::RedisConfig.new.connection_uri, driver: :hiredis)

# set default redis server for redis-mutex
RedisClassy.redis = Redis.current

ActiveJob::Status.store = ActiveSupport::Cache::RedisCacheStore.new(redis: Redis.current)

ActiveJob::Uniqueness.config.redlock_servers = [Redis.current]
