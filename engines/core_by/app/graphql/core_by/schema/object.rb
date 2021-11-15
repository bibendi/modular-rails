# frozen_string_literal: true

module CoreBy
  module Schema
    class Object < ::GraphQL::Schema::Object
      include ActionPolicy::GraphQL::Behaviour
      include ::GraphQL::FragmentCache::Object

      field_class Field

      def preload_association(*args, **kwargs)
        dataloader.with(
          CoreBy::GraphQL::Loaders::AssociationLoader,
          object.class,
          *args,
          **kwargs
        ).load(object)
      end
    end
  end
end
