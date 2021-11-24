# frozen_string_literal: true

module Interests
  class Interest < CoreBy::SDK::ApplicationRecord
    self.entity = SDK::InterestEntity

    has_many :user_interests

    validates_uniqueness_of :name
    validates :name, presence: true

    scope :ordered, -> { order(:name) }
  end
end
