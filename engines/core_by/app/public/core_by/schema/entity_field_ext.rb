# frozen_string_literal: true

module CoreBy
  module Schema
    # GraphQL field extension allows replacing Entity with ActiveRecord object
    class EntityFieldExt < FieldExtension
      def resolve(object:, arguments:, context:, **rest)
        object.object = object.object.to_record if object.object.respond_to?(:to_record)

        yield object, arguments
      end
    end
  end
end
