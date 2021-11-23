# frozen_string_literal: true

module Interests
  module SDK
    class InterestEntity < CoreBy::SDK::ApplicationEntity
      delegate_attrs :id, :name
    end
  end
end
