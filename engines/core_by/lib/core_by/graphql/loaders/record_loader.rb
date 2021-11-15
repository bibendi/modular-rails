# frozen_string_literal: true

module CoreBy
  module GraphQL
    module Loaders
      # See https://graphql-ruby.org/dataloader/sources
      #
      # It supports for multiple column conditions (useful when you want to load a record
      # for current user only).
      #
      # Example:
      #
      #  def my_invitation
      #    dataloader
      #      .with(CoreBy::GraphQL::Loaders::RecordLoader, Invitation)
      #      .load(event_id: object.id, user_id: current_user.id)
      #  end
      #
      # NOTE: values combined into arrays to produce `IN (...)` queries.
      # That means that you should use this loader only when the set of columns
      # is a unique for this relation.
      class RecordLoader < ::GraphQL::Dataloader::Source
        def initialize(model, *_args, scope: nil)
          @model = model
          @scope = scope
        end

        def fetch(keys)
          conditions = build_conditions(keys)
          columns = conditions.keys

          records_by_key = query(conditions).each_with_object({}) do |record, memo|
            key = extract_key(record, columns)
            memo[key] = record
          end

          keys.map { |key| records_by_key.fetch(key, nil) }
        end

        private

        attr_reader :model, :scope

        def query(conditions)
          rel = scope ? model.public_send(scope) : model
          rel.where(conditions).to_a
        end

        def build_conditions(keys)
          # Key contain hashes of conditions ([{a: 1, b: 2}, {a: 2, b: 2}, ...]).
          # Combine them into {a: [1, 2], b: [2, 2]} to use in `where` clause.
          keys.each_with_object(Hash.new { |h, k| h[k] = [] }) do |cond, acc|
            cond.each do |k, v|
              acc[k] << v
            end
            acc
          end.tap do |conditions|
            # remove duplicates
            conditions.transform_values!(&:uniq)
          end
        end

        def extract_key(record, columns)
          columns.each_with_object({}) do |column, memo|
            memo[column] = record.public_send(column)
          end
        end
      end
    end
  end
end
