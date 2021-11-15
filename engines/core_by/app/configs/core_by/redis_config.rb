# frozen_string_literal: true

require "uri"

module CoreBy
  class RedisConfig < Anyway::Config
    config_name :redis

    attr_config :url, :db

    def connection_uri
      if url.present?
        if db.present?
          uri = URI(url)
          uri.path = "/#{db}"
          uri.to_s
        else
          url
        end
      else
        raise "Redis url is not configured"
      end
    end
  end
end
