# frozen_string_literal: true

module CoreBy
  module Events
    module Users
      class Updated < CoreBy::Base::Event
        attributes :user, :changed_fields
      end
    end
  end
end
