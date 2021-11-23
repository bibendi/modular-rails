# frozen_string_literal: true

module Interests
  class UserInterestPolicy < CoreBy::SDK::ApplicationPolicy
    def create?
      !user.nil?
    end
  end
end
