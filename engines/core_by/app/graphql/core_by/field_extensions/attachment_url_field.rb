# frozen_string_literal: true

module CoreBy
  module FieldExtensions
    # GraphQL field extension allows returning URL of Active Storage attachment.
    class AttachmentURLField < ::GraphQL::Schema::FieldExtension
      class AttachmentLoader < ::GraphQL::Dataloader::Source
        CACHE_NAMESPACE = "core_by:attachment_url_field"
        CACHE_EXPIRES_IN = 1.hour

        attr_reader :record_type, :attachment, :variant

        def initialize(record_type:, attachment:, variant:)
          @record_type = record_type
          @attachment = attachment
          @variant = variant&.to_sym
        end

        def fetch(objects)
          @result = {}
          keys = build_keys(objects)

          fulfill_from_cache(keys)
          return result.values if keys.empty?

          records = load_records(keys.values.map(&:id))
          fulfill_and_cache(records, keys)

          objects.each do |object|
            fulfill(object, nil) unless fulfilled?(object)
          end

          result.sort_by { |key, value| objects.index(key) }.map(&:second)
        end

        private

        attr_accessor :result

        def build_keys(objects)
          objects.each_with_object({}) do |object, memo|
            key = "#{CACHE_NAMESPACE}:#{record_type}:#{attachment}:#{variant}:#{object.id}:#{object.updated_at.to_i}"
            memo[key] = object
          end
        end

        def fulfill(key, entry)
          result[key] = entry
        end

        def fulfilled?(key)
          result.key?(key)
        end

        def fulfill_from_cache(keys)
          data = ::Rails.cache.read_multi(*keys.keys)
          return if data.blank?

          data.each do |key, entry|
            fulfill(keys.fetch(key), entry)
          end

          keys.except!(*data.keys)
        end

        def load_records(ids)
          ::ActiveStorage::Attachment
            .includes(:blob)
            .where(name: attachment, record_type: record_type, record_id: ids)
            .to_a
        end

        def fulfill_and_cache(records, keys)
          keys_by_ids = keys.each_with_object({}) do |(key, object), memo|
            memo[object.id] = key
          end

          cache_values = {}
          records.each do |record|
            url = CoreBy::ActiveStorage.attachment_url(record, variant: variant)
            cache_key = keys_by_ids.fetch(record.record_id)
            cache_values[cache_key] = url
            fulfill(keys.fetch(cache_key), url)
          end

          return if cache_values.empty?
          Rails.cache.write_multi(cache_values, expires_in: CACHE_EXPIRES_IN)
        end
      end

      attr_reader :attachment

      def apply
        @attachment = options.fetch(:attachment) { field.original_name.to_s.sub(/_url$/, "") }

        if (variant = options[:variant])
          field.argument(
            :variant,
            variant.fetch(:enum),
            required: variant.fetch(:required),
            description: "Attachment variant"
          )
        end
      end

      def resolve(object:, arguments:, context:, **rest)
        context.dataloader
          .with(AttachmentLoader,
            record_type: object.object.class.base_class.name,
            attachment: attachment,
            variant: arguments[:variant])
          .load(object.object)
      end
    end
  end
end
