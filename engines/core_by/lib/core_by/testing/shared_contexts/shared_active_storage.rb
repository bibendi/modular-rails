# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    Rails.configuration.active_storage.disk_endpoint = "http://localhost"
  end
end
