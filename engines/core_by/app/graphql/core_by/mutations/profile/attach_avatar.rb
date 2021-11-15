# frozen_string_literal: true

module CoreBy
  module Mutations
    module Profile
      class AttachAvatar < Schema::Mutation
        graphql_name "AttachProfileAvatar"

        description "Update the current user's avatar (by attaching a blob via signed ID)"

        argument :blob_id, Types::SignedBlobId, "Signed blob ID for avatar image", required: true

        field :user, Types::User, null: true

        def resolve(blob_id:)
          current_user.avatar.attach(blob_id)

          {user: current_user}
        rescue ActiveSupport::MessageVerifier::InvalidSignature
          fail_with! :unprocessable_entity, "Blob ID is invalid", reason: :invalid_blob
        end
      end
    end
  end
end
