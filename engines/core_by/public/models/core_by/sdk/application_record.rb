# frozen_string_literal: true

module CoreBy
  module SDK
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true

      class << self
        attr_accessor :entity
      end

      def to_entity
        @entity ||= self.class.entity.new(self)
      end
    end
  end
end
