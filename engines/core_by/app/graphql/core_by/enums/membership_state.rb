# frozen_string_literal: true

module CoreBy
  module Enums
    class MembershipState < GraphQL::Schema::Enum
      description "User membership state"

      value "ACTIVE", "User is active", value: "active_membership"
      value "DISABLED", "User cannot use the app", value: "disabled"
    end
  end
end
