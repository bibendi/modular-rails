# frozen_string_literal: true

module CoreBy
  module SDK
    module Types
      class SignedBlobId < ::GraphQL::Types::String
        description "Signed blob ID generated by the `createDirectUpload` mutation"
      end
    end
  end
end
