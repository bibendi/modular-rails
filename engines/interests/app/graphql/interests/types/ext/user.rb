# frozen_string_literal: true

module Interests
  module Types
    module Ext
      module User
        extend ActiveSupport::Concern

        included do
          field :interests, SDK::Types::Interest.connection_type, "User interests", null: false
        end

        def interests
          Interest
            .joins(:user_interests)
            .where(user_interests: {user_id: object.id})
            .ordered
        end
      end
    end
  end
end
