# frozen_string_literal: true

module CoreBy
  module SDK
    module Users
      class Created < ApplicationEvent
        attributes :user
      end
    end
  end
end
