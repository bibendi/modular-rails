# frozen_string_literal: true

return unless defined?(Yabeda)

Sidekiq.configure_server do |_config|
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
