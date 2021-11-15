# frozen_string_literal: true

module CoreBy
  class DirectDb < ActiveRecord::Base
    self.abstract_class = true

    def self.take_connection
      yield connection
    end

    unless Rails.env.test?
      establish_connection :"#{Rails.env}_direct"

      class << self
        delegate :disconnect!, to: :connection

        def reset_connection
          disconnect!
          establish_connection :"#{Rails.env}_direct"
        end

        # TODO: Think about how to disconnect all direct connections in `ensure` block
        def take_connection
          yield connection
        end
      end
    end
  end
end
