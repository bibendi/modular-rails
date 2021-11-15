# frozen_string_literal: true

module CoreBy
  module Types
    class DirectUpload < Schema::Object
      description <<~DESC
        Represents direct upload credentials.

        Use `url` and `headers` to perform the actual file upload
        (see JS example from Active Storage https://github.com/rails/rails/blob/master/activestorage/app/javascript/activestorage/blob_upload.js).

        Blob data (`blob_id` or `signed_blob_id`) could be used in other mutations to attach
        the uploaded file to a record.
      DESC

      field :url, String, "Upload URL (where to PUT the file)", null: false
      field :headers, JSONString,
        "HTTP request headers to perform the upload action (JSON-encoded)",
        null: false
      field :blob_id, ID, "Created blob record ID", null: false
      field :signed_blob_id, ID,
        "Created blob record signed ID (should be used in mutations to attach the file to a record",
        null: false
    end
  end
end
