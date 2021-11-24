# frozen_string_literal: true

module AuthBy
  module Mutations
    class SignIn < CoreBy::SDK::Schema::Mutation
      description <<~DESC
        Sign in a user by given email and password.
      DESC

      class SignInInput < CoreBy::SDK::Schema::Input
        description "User credentials input"

        argument :email, String, required: true
        argument :password, String, required: true
      end

      argument :input, SignInInput, "Credentials input", required: true

      field :user, CoreBy::SDK::Types::User, null: true
      field :access_token, String, "JWT access token", null: true
      field :refresh_token, String, "JWT refresh token", null: true

      def resolve(input:)
        entity_user = CoreBy::SDK::UsersRepository.find_by_email(input.email)
        user = User.find_by_id(entity_user.id) if entity_user && !entity_user.disabled?
        fail_with!(:invalid, "Unauthenticated") unless user&.valid_password?(input.password)

        tokens = user.generate_jwt_tokens
        {
          user: entity_user,
          access_token: tokens.fetch(:access),
          refresh_token: tokens.fetch(:refresh)
        }
      end
    end
  end
end
