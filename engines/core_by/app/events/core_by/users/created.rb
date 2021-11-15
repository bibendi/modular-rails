# frozen_string_literal: true

module CoreBy
  module Users
    class Created < CoreBy::BaseEvent
      attributes :user
    end
  end
end
