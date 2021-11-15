# frozen_string_literal: true

# Google Cloud Storage settings (for ActiveStorage)
# https://edgeguides.rubyonrails.org/active_storage_overview.html#google-cloud-storage-service
# https://googleapis.dev/ruby/google-cloud-storage/latest/file.AUTHENTICATION.html
class GCSConfig < BaseConfig
  attr_config(
    :project,
    :bucket,
    :project_id,
    :private_key_id,
    :private_key,
    :client_email,
    :client_id,
    :client_x509_cert_url
  )
end
