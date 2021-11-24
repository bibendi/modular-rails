# frozen_string_literal: true

module LogrageContext
  def append_info_to_payload(payload)
    super

    payload.merge!(
      user_id: @current_user&.id,
      ip: request.env["HTTP_X_REAL_IP"] || request.remote_ip,
      uuid: request.uuid,
      client: request.user_agent&.first(50)
    )
  end
end

ActiveSupport.on_load("core_by/sdk/application_controller") { include LogrageContext }
ActiveSupport.on_load("core_by/sdk/api_controller") { include LogrageContext }

Rails.application.configure do
  lograge_ignore_params = (%w[controller action format id graphql] + config.filter_parameters.map(&:to_s)).uniq

  config.lograge.enabled = true

  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.base_controller_class = ["ActionController::API", "ActionController::Base"]

  config.lograge.ignore_actions = ["HealthController#live"]

  config.lograge.custom_options = ->(event) do
    next {} if /action_cable/.match?(event.name)

    payload = event.payload

    {
      ts: Time.current.iso8601,
      uuid: payload[:uuid],
      user_id: payload[:user_id],
      ip: payload[:ip],
      client: payload[:client],
      params: payload[:params].except(*lograge_ignore_params).presence,
      exception: payload[:exception]
    }.compact
  end
end
