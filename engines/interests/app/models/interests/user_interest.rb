# frozen_string_literal: true

module Interests
  class UserInterest < CoreBy::SDK::ApplicationRecord
    db_belongs_to :interest

    validates :user_id, presence: true
    validates_uniqueness_of :interest_id, scope: :user_id

    scope :ordered, -> { order(:interest_id) }
  end
end
