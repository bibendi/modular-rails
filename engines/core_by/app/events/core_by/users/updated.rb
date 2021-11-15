# frozen_string_literal: true

module CoreBy
  module Users
    class Updated < CoreBy::BaseEvent
      attributes :user, :changed_fields
    end
  end
end
