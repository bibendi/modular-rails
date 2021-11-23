# frozen_string_literal: true

module CoreBy
  module SDK
    module Types
      class Date < ::GraphQL::Schema::Scalar
        description "An ISO 8601-encoded date (without time)"

        def self.coerce_input(input_value, *)
          ::Date.iso8601(input_value)
        rescue ArgumentError
          nil
        end

        def self.coerce_result(ruby_value, *)
          ruby_value.iso8601
        end
      end
    end
  end
end
