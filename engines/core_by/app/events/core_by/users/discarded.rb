# frozen_string_literal: true

module CoreBy
  module Users
    class Discarded < CoreBy::BaseEvent
      attributes :user
    end
  end
end
