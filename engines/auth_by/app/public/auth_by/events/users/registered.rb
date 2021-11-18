# frozen_string_literal: true

module AuthBy
  module Events
    module Users
      class Registered < CoreBy::Base::Event
        attributes :user
      end
    end
  end
end
