# frozen_string_literal: true

module CoreBy
  module GraphQL
    module EntityBehaviour
      class EntityFieldExt < ::GraphQL::Schema::FieldExtension
        def resolve(object:, arguments:, context:, **rest)
          if object.respond_to?(:object=) && object.object.respond_to?(:to_record, true)
            object.object = object.object.send(:to_record)
          end

          yield object, arguments
        end
      end

      module EntityField
        def initialize(*args, **kwargs, &block)
          extensions = (kwargs[:extensions] ||= [])

          extension = {EntityFieldExt => {}}

          if extensions.is_a?(Hash)
            extensions.merge!(extension)
          else
            extensions << extension
          end

          super(*args, **kwargs, &block)
        end
      end

      def self.included(base)
        return unless base.respond_to?(:field_class)

        unless base.field_class < EntityField
          base.field_class.prepend EntityField
        end
      end
    end
  end
end
