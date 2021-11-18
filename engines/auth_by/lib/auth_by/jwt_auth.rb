# frozen_string_literal: true

module AuthBy
  class JwtAuth
    Error = Class.new(StandardError)
    ExpiredToken = Class.new(Error)
    InvalidToken = Class.new(Error)

    include JWTSessions::Authorization

    attr_reader :request

    delegate :headers, :cookies, :method, :params, to: :request, prefix: true

    public :payload, :claimless_payload

    def initialize(request)
      @request = request
    end

    def current_user
      return @current_user if defined?(@current_user)

      @current_user =
        if request_has_token?
          begin
            authorize_access_request!
            user = CoreBy::SDK::Users.find_by_id(payload["user_id"])
            return user unless user&.disabled?
          rescue JWTSessions::Errors::Unauthorized => e
            if /signature has expired/i.match?(e.message)
              raise ExpiredToken
            else
              raise InvalidToken
            end
          end
        end
    end

    private

    def authorize_access_request!
      if request_headers[JWTSessions.access_header].present?
        cookieless_auth(:access)
      elsif request_cookies[JWTSessions.access_cookie].present?
        cookie_based_auth(:access)
      else
        params_based_auth(:access)
      end

      authorize_request(:access)
    end

    def params_based_auth(token_type)
      @_csrf_check = false
      @_raw_token = token_from_params(token_type)
    end

    def token_from_params(token_type)
      token = request_params[JWTSessions.cookie_by(token_type)]
      raise JWTSessions::Errors::Unauthorized, "Token is not found" unless token
      token
    end

    def request_has_token?
      request_headers[JWTSessions.access_header].present? ||
        request_cookies[JWTSessions.access_cookie].present? ||
        request_params[JWTSessions.access_cookie].present?
    end
  end
end
