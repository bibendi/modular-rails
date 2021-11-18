# frozen_string_literal: true

module CoreBy
  module Base
    class Policy < ActionPolicy::Base
      authorize :user, allow_nil: true

      private

      def owner?
        return false unless record&.user_id
        record.user_id == user&.id
      end

      def community_manager?
        !!user&.community_manager?
      end

      def allow_community_managers
        allow! if community_manager?
      end
    end
  end
end
