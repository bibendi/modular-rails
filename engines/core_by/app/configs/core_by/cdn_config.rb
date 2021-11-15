# frozen_string_literal: true

module CoreBy
  class CdnConfig < Anyway::Config
    config_name :cdn

    attr_config :endpoint, :key, :key_name, :expires_in
  end
end
