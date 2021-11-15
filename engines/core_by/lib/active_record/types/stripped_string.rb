# frozen_string_literal: true

module ActiveRecord
  module Types
    class StrippedString < Type::String
      def cast(value)
        value = value.strip.presence unless value.nil?
        super(value)
      end
    end
  end
end
