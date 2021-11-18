# frozen_string_literal: true

module CoreBy
  module Schema
    class AttachmentVariantEnum < Enum
      def self.variants_for(model, attachment)
        description "#{model.model_name.human} #{attachment} image variants"

        model
          .attachments_variants
          .fetch(attachment)
          .fetch(:image_processing)
          .each do |variant, options|
            value variant.to_s, options.map { |k, v| "#{k}: #{v}" }.join("\n"), value: variant
          end
      end
    end
  end
end
