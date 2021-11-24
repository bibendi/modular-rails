# frozen_string_literal: true

require "json"

module CoreBy
  module SDK
    module Types
      class JSONString < ::GraphQL::Schema::Scalar
        description "Any object, transported as a JSON string (`#to_json`)"

        def self.coerce_input(input_value, *)
          # Parse the incoming object
          JSON.parse(input_value)
        rescue JSON::ParseError
          raise GraphQL::CoercionError, "#{input_value.inspect} is not a valid JSON"
        end

        def self.coerce_result(ruby_value, *)
          ruby_value.to_json
        end
      end
    end
  end
end
