# frozen_string_literal: true

require "core_by"
require "database_validations"
require "jwt_sessions"
require "sorcery"
require "slim-rails"

module AuthBy
  autoload :JwtAuth, "auth_by/jwt_auth"

  class << self
    def table_name_prefix
      ""
    end
  end
end

require "auth_by/engine"
