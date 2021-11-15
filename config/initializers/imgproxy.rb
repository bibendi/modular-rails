# frozen_string_literal: true

Rails.application.config.imgproxy.tap do |imgproxy|
  raise "Imgproxy needs to be configured" unless imgproxy.configured?

  Imgproxy.configure do |config|
    config.endpoint = imgproxy.endpoint
    config.key = imgproxy.key
    config.salt = imgproxy.salt
  end
end
