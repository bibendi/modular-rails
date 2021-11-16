# frozen_string_literal: true

module AuthBy
  module Mutations
    class SignOut < CoreBy::Schema::Mutation
      description <<~DESC
        Sign out a user (flush JWT session).
      DESC

      argument :refresh_token, String, "JWT refresh token", required: true

      field :user_id, Integer, null: true

      def resolve(refresh_token:)
        refresh_payload = JWTSessions::Token.decode(refresh_token).first
        unless JWTSessions::Session.new.session_exists?(refresh_token, :refresh)
          fail_with! :unauthenticated, "Refresh token is invalid", reason: :token_invalid
        end

        user = User.find_by_id(refresh_payload["user_id"])

        JWTSessions::Session.new(namespace: user.jwt_namespace)
          .flush_by_token(refresh_token)

        {user_id: user.id}
      rescue JWTSessions::Errors::Unauthorized
        fail_with! :unauthenticated, "Malicious activity detected", reason: :token_invalid
      end
    end
  end
end
