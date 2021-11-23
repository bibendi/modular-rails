# frozen_string_literal: true

module Interests
  module SDK
    module UserInterestsRepository
      module_function

      # TODO: I think we need implement pagination
      def fetch(user_id, limit: 1000)
        InterestEntity.from_list(
          Interest
            .joins(:user_interests)
            .where(user_interests: {user_id: user_id})
            .ordered
            .limit(limit)
        )
      end
    end
  end
end
