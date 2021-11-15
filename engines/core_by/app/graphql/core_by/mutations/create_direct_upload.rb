# frozen_string_literal: true

module CoreBy
  module Mutations
    class CreateDirectUpload < Schema::Mutation
      description <<~DESC
        Creates a new blob on the server side in anticipation of a direct-to-service upload from the client.
        When the client-side upload is completed, the signed_blob_id can be submitted as part of the form to reference
        the blob that was created up front.

        Based on https://github.com/rails/rails/blob/master/activestorage/app/controllers/active_storage/direct_uploads_controller.rb
      DESC

      class CreateDirectUploadInput < Schema::Input
        description "File information required to prepare a direct upload"

        argument :filename, String, "Original file name", required: true
        argument :byte_size, Int, "File size (in bytes)", required: true
        argument :checksum, String, "MD5 file contents checksum encoded as base64", required: true
        argument :content_type, String, "File content type", required: true
      end

      argument :input, CreateDirectUploadInput, "File information required to prepare a direct upload", required: true

      field :direct_upload, Types::DirectUpload, null: false

      def resolve(input:)
        blob = ::ActiveStorage::Blob.create!(
          filename: input.filename,
          byte_size: input.byte_size,
          checksum: input.checksum,
          content_type: input.content_type
        )

        {
          direct_upload: {
            url: blob.service_url_for_direct_upload,
            headers: blob.service_headers_for_direct_upload,
            blob_id: blob.key,
            signed_blob_id: blob.signed_id
          }
        }
      end
    end
  end
end
