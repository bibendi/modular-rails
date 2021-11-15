# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Mutations::Profile::AttachAvatar do
  let(:query) do
    <<~GRAPHQL
      mutation attachProfileAvatar($blobId: SignedBlobId!) {
        attachProfileAvatar(blobId: $blobId) {
          user {
            avatarUrl(variant: basic)
          }
        }
      }
    GRAPHQL
  end

  let(:blob) { create(:blob, filename: "test.jpg") }

  let(:variables) { {blob_id: blob.signed_id} }

  include_examples "field is not accessible to unauthenticated users", "attachProfileAvatar"

  it "updates current user's avatar" do
    subject

    expect(user.reload.avatar.blob.filename).to eq "test.jpg"

    expect(data.fetch("user").fetch("avatarUrl")).not_to be_nil
  end
end
