# frozen_string_literal: true

config = AuthBy::JWTSessionsConfig.new

JWTSessions.token_store = config.store
JWTSessions.access_exp_time = config.access_exp_time
JWTSessions.refresh_exp_time = config.refresh_exp_time

# Use Rails app secret for jwt sessions
JWTSessions.encryption_key = Rails.application.secret_key_base
