# frozen_string_literal: true

module Interests
  class Interest < CoreBy::Base::ApplicationRecord
    self.entity = Entities::Interest

    has_many :user_interests

    validates_uniqueness_of :name
    validates :name, presence: true

    scope :ordered, -> { order(:name) }
  end
end
