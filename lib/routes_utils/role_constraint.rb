# frozen_string_literal: true

# Checks that current user satisfies the specified
# role.
#
# Supports both session-based and JWT-based
# authenticated (the latter one could be used
# to access the private APIs)
class RoleConstraint
  include JWTSessions::RailsAuthorization

  class << self
    alias_method :[], :new
  end

  attr_reader :roles

  def initialize(*roles)
    @roles = roles.freeze
  end

  def matches?(request)
    user_id = request.session[:user_id] || user_id_from_jwt(request)
    return false unless user_id
    !CoreBy::User.select(:role).find_by(role: roles, id: user_id).nil?
  rescue JWTSessions::Errors::Unauthorized
    false
  end

  private

  def user_id_from_jwt(request)
    # See https://github.com/tuwukee/jwt_sessions/blob/v2.2.1/lib/jwt_sessions/authorization.rb
    return unless request.headers[JWTSessions.access_header].present?

    raw_token = request.headers[JWTSessions.access_header]
    return unless jwt_session_exists?(raw_token)

    token = raw_token.split(" ")[-1]
    payload = JWTSessions::Token.decode(token, {}).first
    payload["user_id"]
  end

  def jwt_session_exists?(token)
    JWTSessions::Session.new.session_exists?(token, :access)
  end
end
