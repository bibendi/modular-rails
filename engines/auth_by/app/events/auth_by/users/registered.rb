# frozen_string_literal: true

module AuthBy
  module Users
    class Registered < CoreBy::BaseEvent
      attributes :user
    end
  end
end
