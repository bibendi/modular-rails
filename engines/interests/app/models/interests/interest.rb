# frozen_string_literal: true

module Interests
  class Interest < CoreBy::Base::ApplicationRecord
    validates :name, presence: true
  end
end
