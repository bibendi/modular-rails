# frozen_string_literal: true

module AuthBy
  class JWTSessionsConfig < Anyway::Config
    config_name :jwt_sessions

    attr_config :store_type, :access_exp_time, :refresh_exp_time

    def store
      case store_type
      when "redis"
        [:redis, {redis_client: Redis.current}]
      when "memory"
        :memory
      else
        raise ArgumentError, "Unknown store type: #{store_type}"
      end
    end
  end
end
