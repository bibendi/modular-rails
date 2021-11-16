# frozen_string_literal: true

module AuthBy
  module Mutations
    class RefreshToken < CoreBy::Schema::Mutation
      description <<~DESC
        Refresh a JWT access token.

        The provided token must be expired.
      DESC

      argument :refresh_token, String, "JWT refresh token", required: true

      field :access_token, String, "JWT access token", null: true

      def resolve(refresh_token:)
        begin
          refresh_payload = JWTSessions::Token.decode(refresh_token).first
        rescue JWTSessions::Errors::Expired
          fail_with! :unauthenticated, "Refresh token is expired", reason: :token_expired
        rescue JWTSessions::Errors::Unauthorized
          fail_with! :unauthenticated, "Malicious activity detected", reason: :token_invalid
        end

        user = User.kept.find_by(id: refresh_payload["user_id"])
        unless user
          fail_with! :unauthenticated, "Unauthenticated access to the field refreshToken", reason: :user_not_found
        end

        session = JWTSessions::Session.new(namespace: user.jwt_namespace, **user.jwt_payload)

        tokens = session.refresh(refresh_token)
        {access_token: tokens[:access]}
      rescue JWTSessions::Errors::Unauthorized
        fail_with! :unauthenticated, "Refresh token is invalid", reason: :token_invalid
      end
    end
  end
end