# frozen_string_literal: true

module AuthBy
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      rescue_from JwtAuth::ExpiredToken, with: :jwt_token_expired
      rescue_from JwtAuth::InvalidToken, with: :jwt_token_invalid
    end

    # NOTE: `current_user` is an `AuthBy::User` instance but API relies on
    # `CoreBy::User`; we don't want to expose `AuthBy::User`.
    def current_user
      return @current_user if defined?(@current_user)

      @current_user = jwt_auth.current_user || login_from_session || login_from_other_sources || nil
      @current_user = @current_user&.becomes(CoreBy::User)
    end

    private

    def jwt_auth
      @jwt_auth ||= JwtAuth.new(request)
    end

    def jwt_token_expired
      respond_with_error("Unauthenticated access", status: 401, code: :unauthenticated, reason: :token_expired)
    end

    def jwt_token_invalid
      respond_with_error("Unauthenticated access", status: 401, code: :unauthenticated, reason: :token_invalid)
    end
  end
end
