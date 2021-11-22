# frozen_string_literal: true

module Interests
  class UserInterest < CoreBy::Base::ApplicationRecord
    db_belongs_to :interest
    # We cannot use this association due to Packwerk
    # db_belongs_to :user, class_name: "CoreBy::User"

    validates :user_id, presence: true
    validates_uniqueness_of :interest_id, scope: :user_id
  end
end
