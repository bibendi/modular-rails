# frozen_string_literal: true

require "base64"
require "openssl"
require "time"
require "cgi"

module ActiveStorage
  class Service
    def disk?
      false
    end

    def gcs?
      false
    end

    def signed_cdn_url(key, expires_in:, filename:, disposition:, content_type:)
      raise NotImplementedError
    end
  end
end

module ActiveStorage
  class Service::DiskService < Service
    def disk?
      true
    end
  end
end

module ActiveStorage
  class Service::GCSService < Service
    def gcs?
      true
    end

    def signed_cdn_url(key, filename:, content_type:, disposition:, expires_in: nil)
      decoded_key = Base64.urlsafe_decode64(cdn_config.key)
      expires_in ||= cdn_config.expires_in
      expiration_utc = (Time.now.utc + expires_in.seconds).to_i

      disposition = "response-content-disposition=#{CGI.escape(content_disposition_with(type: disposition, filename: filename))}"
      content_type = "response-content-type=#{CGI.escape(content_type)}"

      url = "#{cdn_config.endpoint}/#{key}?#{disposition}&#{content_type}&Expires=#{expiration_utc}&KeyName=#{cdn_config.key_name}"

      signature = OpenSSL::HMAC.digest("SHA1", decoded_key, url)
      encoded_signature = Base64.urlsafe_encode64(signature)

      "#{url}&Signature=#{encoded_signature}"
    end

    def gs_url(key)
      "gs://#{bucket.name}/#{key}"
    end

    private

    def cdn_config
      @cdn_config ||= ::CoreBy::CdnConfig.new
    end
  end
end
