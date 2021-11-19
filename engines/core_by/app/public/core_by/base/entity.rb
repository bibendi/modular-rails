# frozen_string_literal: true

module CoreBy
  module Base
    class Entity
      class << self
        def from(record)
          new(record) if record
        end

        def delegate_attrs(*attrs)
          delegate(*attrs, to: :record)
        end
      end

      def initialize(record)
        @record = record
      end

      def ==(other)
        super ||
          other.instance_of?(self.class) &&
            !record.nil? &&
            other.record == record
      end

      protected

      attr_reader :record

      private

      # We need this method because graphql types are relies on active record models.
      # Basically, we can use send an entity to graphql type, but we should not do that because of:
      # - we have to be insync with graphql type (i.e., having the same attributes)
      # - we don't want implement new type of relay connections
      def to_record
        record
      end
    end
  end
end
