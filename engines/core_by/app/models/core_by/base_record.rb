# frozen_string_literal: true

module CoreBy
  class BaseRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
