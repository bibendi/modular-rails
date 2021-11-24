# frozen_string_literal: true

module AuthBy
  module SDK
    module Users
      class Registered < CoreBy::SDK::ApplicationEvent
        attributes :user
      end
    end
  end
end
