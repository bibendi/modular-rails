# frozen_string_literal: true

module CoreBy
  module Mutations
    module Profile
      class Discard < Schema::Mutation
        graphql_name "DiscardProfile"

        description "Request to delete current user's profile"

        field :user, Types::User, null: false

        def resolve
          CoreBy::Users::Discard.call(current_user)

          {user: current_user}
        end
      end
    end
  end
end
