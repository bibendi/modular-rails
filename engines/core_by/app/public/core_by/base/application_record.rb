# frozen_string_literal: true

module CoreBy
  module Base
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
