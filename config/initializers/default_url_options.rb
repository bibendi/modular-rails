# frozen_string_literal: true

# Configure default url options for routes and mailers
[
  Rails.application,
  CoreBy::Engine.routes,
  AuthBy::Engine.routes
].each do |app|
  app.default_url_options[:host] = Rails.application.config.app.host
  app.default_url_options[:port] = Rails.application.config.app.port
end
