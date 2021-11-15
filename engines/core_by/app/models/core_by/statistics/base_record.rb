# frozen_string_literal: true

module CoreBy
  module Statistics
    class BaseRecord < CoreBy::BaseRecord
      self.abstract_class = true

      connects_to database: {reading: :statistics, writing: :statistics}
    end
  end
end
