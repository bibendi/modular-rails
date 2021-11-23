# frozen_string_literal: true

module CoreBy
  module SDK
    class StatisticsRecord < ApplicationRecord
      self.abstract_class = true

      connects_to database: {reading: :statistics, writing: :statistics}
    end
  end
end
