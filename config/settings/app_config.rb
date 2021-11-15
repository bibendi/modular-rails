# frozen_string_literal: true

# General project settings
class AppConfig < BaseConfig
  attr_config(
    :host,
    :port,
    :title,
    :description,
    :cable_adapter,
    :cable_url,
    :active_storage_service,
    :active_storage_disk_internal_endpoint,
    protocol: "http"
  )

  def endpoint
    @endpoint ||= "#{protocol}://#{host}#{":#{port}" if port}"
  end
end
