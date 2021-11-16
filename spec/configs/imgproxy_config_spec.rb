# frozen_string_literal: true

require "rails_helper"

describe ImgproxyConfig, type: :config do
  subject { described_class.new }

  specify do
    with_env(
      "IMGPROXY_ENDPOINT" => "imgproxy.test",
      "IMGPROXY_SOURCE_HOST" => "vicinity.test",
      "IMGPROXY_KEY" => "key",
      "IMGPROXY_SALT" => "salt"
    ) do
      is_expected.to have_attributes(
        endpoint: "imgproxy.test",
        source_host: "vicinity.test",
        key: "key",
        salt: "salt"
      )
    end
  end
end
