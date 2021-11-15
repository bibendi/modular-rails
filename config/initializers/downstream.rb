# frozen_string_literal: true

Downstream.configure do |config|
  config.pubsub = :stateless
  config.async_queue = :default
end
