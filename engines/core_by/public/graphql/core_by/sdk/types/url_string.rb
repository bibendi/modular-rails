# frozen_string_literal: true

require "uri"

module CoreBy
  module SDK
    module Types
      class URLString < ::GraphQL::Schema::Scalar
        description "A valid URL, transported as a string"

        def self.coerce_input(input_value, *)
          url = URI.parse(input_value)
          # It's valid, return as string
          return url.to_s if url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)

          raise GraphQL::CoercionError, "#{input_value.inspect} is not a valid URL"
        end

        def self.coerce_result(ruby_value, *)
          ruby_value.to_s
        end
      end
    end
  end
end
