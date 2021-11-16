# frozen_string_literal: true

module AuthBy
  class User < CoreBy::User
    authenticates_with_sorcery!

    default_scope -> { where.not(membership_state: "disabled") }

    def jwt_payload
      {payload: {user_id: id}, refresh_payload: {user_id: id}}
    end

    def jwt_namespace
      "user-#{id}"
    end

    def generate_jwt_tokens
      raise ArgumentError, "User has no id" unless persisted?

      session = JWTSessions::Session.new(namespace: jwt_namespace, **jwt_payload)
      tokens = session.login
      {access: tokens.fetch(:access), refresh: tokens.fetch(:refresh)}
    end

    def flush_jwt_tokens
      JWTSessions::Session.new(namespace: jwt_namespace).flush_namespaced
    end
  end
end
