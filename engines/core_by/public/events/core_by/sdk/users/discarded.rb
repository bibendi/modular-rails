# frozen_string_literal: true

module CoreBy
  module SDK
    module Users
      class Discarded < ApplicationEvent
        attributes :user
      end
    end
  end
end
