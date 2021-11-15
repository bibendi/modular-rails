# frozen_string_literal: true

module CoreBy
  module Mutations
    module Profile
      class UpdateInfo < Schema::Mutation
        graphql_name "UpdateProfileInfo"

        description "Update the current user's profile information (basic fields)"

        class UpdateProfileInfoInput < GraphQL::Schema::InputObject
          description "Update profile info input"

          argument :login, String, "User name, e.g. 'john.green'", required: false
          argument :name, String, "Real name, e.g. 'John Green'", required: false
        end

        argument :input, UpdateProfileInfoInput, "Update profile info input", required: true

        field :user, Types::User, null: true
        field :errors, Types::ValidationErrors, null: true

        def resolve(input:)
          form = CoreBy::Users::UpdateForm.new(current_user, input.to_h)

          if form.save
            {user: form.user}
          else
            {errors: form.errors}
          end
        end
      end
    end
  end
end
