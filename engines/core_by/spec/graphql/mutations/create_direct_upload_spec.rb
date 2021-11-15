# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Mutations::CreateDirectUpload do
  let(:query) do
    <<~GRAPHQL
      mutation getDirectUpload($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          directUpload {
            url
            headers
            blobId
            signedBlobId
          }
        }
      }
    GRAPHQL
  end

  let(:file) { fixture_file_upload("blob.jpg", "image/jpg") }

  let(:variables) do
    {
      input: {
        "filename" => "new.jpg",
        "byteSize" => file.size,
        "checksum" => Digest::MD5.base64digest(file.read),
        "contentType" => file.content_type
      }
    }
  end

  # Make sure that Current.host is present (it's used to generate
  # the direct upload url for disk service)
  before { ActiveStorage::Current.host = "localhost" }

  include_examples "field is not accessible to unauthenticated users", "createDirectUpload"

  it "returns direct upload data" do
    expect { subject }.to change(ActiveStorage::Blob, :count).by(1)

    blob = ActiveStorage::Blob.find_by!(key: data.fetch("directUpload").fetch("blobId"))

    # File hasn't been uploaded
    expect(blob.service.exist?(blob.key)).to eq false
    expect(blob.filename).to eq "new.jpg"
  end
end
