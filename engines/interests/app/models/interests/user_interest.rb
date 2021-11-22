# frozen_string_literal: true

module Interests
  class UserInterest < CoreBy::Base::ApplicationRecord
    db_belongs_to :interest
    db_belongs_to :user, class_name: "CoreBy::User"
  end
end
