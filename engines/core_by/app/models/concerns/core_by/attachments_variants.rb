# frozen_string_literal: true

module CoreBy
  module AttachmentsVariants
    def self.extended(base)
      base.class_eval do
        class_attribute :attachments_variants, default: {}
      end
    end

    def has_one_attachment(name, variants: nil, **options)
      has_one_attached(name, **options)

      add_variants(name, variants) if variants
    end

    def has_many_attachments(name, variants: nil, **options)
      has_many_attached(name, **options)

      add_variants(name, variants) if variants
    end

    def add_variants(name, variants)
      attachments_variants[name] = {
        image_processing: variants,
        imgproxy: imgproxy_variants(variants)
      }
    end

    def imgproxy_variants(variants)
      variants.each_with_object({}) do |(name, transformations), memo|
        memo[name] = imgproxy_transformations(transformations)
      end
    end

    def imgproxy_transformations(transformations)
      transformations.each_with_object({}) do |(key, value), memo|
        case key
        when :resize_to_fit
          memo[:resizing_type] = :fit
          memo[:width] = value.first
          memo[:height] = value.second
        when :resize_to_fill
          memo[:resizing_type] = :fill
          memo[:width] = value.first
          memo[:height] = value.second
        when :quality
          memo[:quality] = Integer(value)
        else
          raise "Unknown transformation #{key}. Please, " /
            "go at https://github.com/imgproxy/imgproxy/blob/master/docs/generating_the_url_advanced.md#processing-options" /
            "and add new option to the converter"
        end
      end
    end
  end
end
