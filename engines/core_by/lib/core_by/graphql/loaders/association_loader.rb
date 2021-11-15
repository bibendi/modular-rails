# frozen_string_literal: true

module CoreBy
  module GraphQL
    module Loaders
      # See https://graphql-ruby.org/dataloader/sources
      class AssociationLoader < ::GraphQL::Dataloader::Source
        def initialize(model, association_schema, scope_model: nil, scopes: nil)
          @model = model
          @association_schema = association_schema
          @association_name = extract_association_id(association_schema)

          if scope_model && scopes
            @preload_scope = scopes.reduce(scope_model) { |acc, scope| acc.public_send(scope) }
          end

          validate
        end

        def fetch(records)
          # Pass unique records to preloader to avoid duplicates
          preload_association(records.uniq)
          records.map { |record| read_association(record) }
        end

        private

        def validate
          unless @model.reflect_on_association(@association_name)
            raise ArgumentError, "No association #{@association_name} on #{@model}"
          end
        end

        def preload_association(records)
          ::ActiveRecord::Associations::Preloader.new.preload(
            records,
            @association_schema,
            @preload_scope
          ).then(&:first).then do |preloader|
            next unless @preload_scope
            # The result of previous preload is memoized, ActiveRecord won't load this association again.
            if preloader.is_a?(::ActiveRecord::Associations::Preloader::AlreadyLoaded)
              raise ArgumentError,
                "Preloading association twice with scopes is not possible. " \
                "To resolve this problem add a scoped association (e.g., `has_many :records, -> { scope_name }, ...`) to the model"
            end
            # this commit changes the way preloader works with scopes
            # https://github.com/rails/rails/commit/2847653869ffc1ff5139c46e520c72e26618c199#diff-3bba5f66eb1ed62bd5700872fcd6c632
            preloader.send(:owners).each do |owner|
              preloader.send(:associate_records_to_owner, owner, preloader.records_by_owner[owner] || [])
            end
          end
        end

        def read_association(record)
          record.public_send(@association_name)
        end

        def extract_association_id(id_or_hash)
          return id_or_hash unless id_or_hash.is_a?(Hash)

          if id_or_hash.keys.size != 1
            raise ArgumentError, "You can only preload exactly one association! You passed: #{id_or_hash}"
          end

          id_or_hash.keys.first
        end
      end
    end
  end
end
