# frozen_string_literal: true

class ImgproxyConfig < BaseConfig
  attr_config :endpoint,
    :source_host,
    :key,
    :salt

  def configured?
    endpoint.present?
  end
end
