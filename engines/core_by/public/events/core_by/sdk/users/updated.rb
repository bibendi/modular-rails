# frozen_string_literal: true

module CoreBy
  module SDK
    module Users
      class Updated < ApplicationEvent
        attributes :user, :changed_fields
      end
    end
  end
end
