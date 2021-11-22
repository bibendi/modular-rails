# frozen_string_literal: true

module Interests
  class Interest < CoreBy::Base::ApplicationRecord
    validates_uniqueness_of :name
    validates :name, presence: true
  end
end
