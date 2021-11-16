# frozen_string_literal: true

require "rails_helper"

describe AppConfig, type: :config do
  subject { described_class.new }

  specify do
    with_env(
      "APP_PROTOCOL" => "https",
      "APP_HOST" => "example.com",
      "APP_PORT" => "3050",
      "APP_CABLE_ADAPTER" => "steroid_adapter",
      "APP_CABLE_URL" => "ws://example.com",
      "APP_ACTIVE_STORAGE_SERVICE" => "local",
      "APP_ACTIVE_STORAGE_DISK_INTERNAL_ENDPOINT" => "ftp://example.com"
    ) do
      is_expected.to have_attributes(
        host: "example.com",
        port: 3050,
        protocol: "https",
        cable_adapter: "steroid_adapter",
        cable_url: "ws://example.com",
        active_storage_service: "local",
        active_storage_disk_internal_endpoint: "ftp://example.com"
      )

      expect(subject.endpoint).to eq "https://example.com:3050"
    end
  end
end
