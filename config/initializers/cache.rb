# frozen_string_literal: true

if Rails.env.development?
  Rails.cache.logger = Logger.new($stdout)
  GraphQL::FragmentCache.cache_store.logger = Logger.new($stdout)
end

if Rails.env.production? || Rails.env.staging?
  ActiveSupport.on_load("core_by/application_schema") do
    configure_persisted_query_store(
      :redis,
      redis_client: {redis_url: ENV.fetch("CACHE_REDIS_URL")}
    )
  end
end
