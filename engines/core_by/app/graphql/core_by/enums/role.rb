# frozen_string_literal: true

module CoreBy
  module Enums
    class Role < Schema::Enum
      description "User role"

      value "MEMBER", "Member", value: "member"
      value "ADMIN", "Administrator or manager", value: "admin"
    end
  end
end
