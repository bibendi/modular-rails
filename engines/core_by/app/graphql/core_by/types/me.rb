# frozen_string_literal: true

module CoreBy
  module Types
    class Me < Schema::Object
      description <<~DESC
        Me type contains the sub-graph for the current authenticated user.
        Use it to get user's personal information and the related entities
      DESC

      field :user, User, "Current user's data", null: false

      def user
        current_user
      end
    end

    ActiveSupport.run_load_hooks("core_by/types/me", Me)
  end
end
