# frozen_string_literal: true

module CoreBy
  module SDK
    class ApplicationEvent < Downstream::Event
      def initialize(event_id: nil, **params)
        safe_params = params.each_with_object({}) do |(k, v), memo|
          memo[k] = if v.respond_to?(:to_entity)
            v.to_entity
          else
            v
          end
        end

        super event_id: event_id, **safe_params
      end
    end
  end
end
