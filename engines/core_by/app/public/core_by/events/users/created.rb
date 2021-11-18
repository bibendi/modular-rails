# frozen_string_literal: true

module CoreBy
  module Events
    module Users
      class Created < CoreBy::Base::Event
        attributes :user
      end
    end
  end
end
