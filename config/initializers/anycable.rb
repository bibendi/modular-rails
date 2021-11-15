# frozen_string_literal: true

return unless defined?(Yabeda)

AnyCable.configure_server do
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
