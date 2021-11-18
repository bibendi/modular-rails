# frozen_string_literal: true

module AuthBy
  module Mutations
    class SignIn < CoreBy::Schema::Mutation
      description <<~DESC
        Sign in a user by given email and password.
      DESC

      class SignInInput < GraphQL::Schema::InputObject
        description "User credentials input"

        argument :email, String, required: true
        argument :password, String, required: true
      end

      argument :input, SignInInput, "Credentials input", required: true

      field :user, CoreBy::Types::User, null: true
      field :access_token, String, "JWT access token", null: true
      field :refresh_token, String, "JWT refresh token", null: true

      def resolve(input:)
        core_user = CoreBy::SDK::Users.find_by_email(input.email)
        user = User.find_by_id(core_user.id) if core_user && !core_user.disabled?
        fail_with!(:invalid, "Unauthenticated") unless user&.valid_password?(input.password)

        tokens = user.generate_jwt_tokens
        {
          user: core_user.to_record,
          access_token: tokens.fetch(:access),
          refresh_token: tokens.fetch(:refresh)
        }
      end
    end
  end
end
