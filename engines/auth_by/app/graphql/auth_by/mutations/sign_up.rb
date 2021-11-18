# frozen_string_literal: true

module AuthBy
  module Mutations
    class SignUp < CoreBy::Schema::Mutation
      description <<~DESC
        Register user by email.

        Create a user and return back JWT access token.
      DESC

      class SignUpInput < CoreBy::Schema::Input
        description "Register user input"

        argument :email, String, "User email", required: true
        argument :password, String, "User password", required: true
        argument :password_confirmation, String, "User password again to confirm", required: true
      end

      argument :input, SignUpInput, required: true

      field :user, CoreBy::Types::User, null: true
      field :access_token, String, "JWT access token", null: true
      field :refresh_token, String, "JWT refresh token", null: true
      field :errors, CoreBy::Types::ValidationErrors, "Errors when a user cannot be created", null: true

      def resolve(input:)
        form = RegisterUserForm.new(input.to_h)

        if form.save
          tokens = form.user.generate_jwt_tokens
          core_user = CoreBy::SDK::Users.find_by_id(form.user.id)

          {
            user: core_user.to_record,
            access_token: tokens[:access],
            refresh_token: tokens[:refresh]
          }
        else
          {errors: form.errors}
        end
      end
    end
  end
end
