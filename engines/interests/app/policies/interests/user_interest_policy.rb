# frozen_string_literal: true

module Interests
  class UserInterestPolicy < CoreBy::Base::Policy
    def create?
      !user.nil?
    end
  end
end
