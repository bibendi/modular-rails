# frozen_string_literal: true

module CoreBy
  module ActiveStorage
    module_function

    def attachment_url(attachment, variant: nil, force_internal_host: false)
      return unless attachment
      return if attachment.respond_to?(:attached?) && !attachment.attached?

      setup_disk_host(variant, force_internal_host) if attachment.service.disk?

      if variant
        transformations = attachment.record.class
          .attachments_variants
          .fetch(attachment.name.to_sym)
        url = attachment.service.gcs? ? attachment.service.gs_url(attachment.blob.key) : attachment.url
        Imgproxy.url_for(url, transformations.fetch(:imgproxy).fetch(variant))
      else
        attachment.service.gcs? ? signed_cdn_url(attachment) : attachment.url
      end
    end

    def setup_disk_host(imgproxy_variant_requested, force_internal_host)
      ::ActiveStorage::Current.host = \
        if imgproxy_variant_requested
          internal_disk_host
        else
          force_internal_host ? internal_disk_host : disk_host
        end
    end

    def disk_host
      @disk_host ||= Rails.configuration.active_storage.disk_endpoint
    end

    def internal_disk_host
      @internal_disk_host ||= Rails.configuration.active_storage.disk_internal_endpoint ||
        Rails.configuration.active_storage.disk_endpoint
    end

    def signed_cdn_url(attachment)
      content_type = attachment.content_type
      is_binary = ::ActiveStorage.content_types_to_serve_as_binary.include?(content_type)
      allowed_inline = ::ActiveStorage.content_types_allowed_inline.include?(content_type)

      content_type = is_binary ? ::ActiveStorage.binary_content_type : content_type
      disposition = is_binary || !allowed_inline ? :attachment : :inline
      filename = ::ActiveStorage::Filename.wrap(attachment.filename)

      attachment.service.signed_cdn_url(attachment.key, content_type: content_type, disposition: disposition, filename: filename)
    end
  end
end
