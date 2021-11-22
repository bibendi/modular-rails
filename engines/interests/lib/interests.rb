# frozen_string_literal: true

require "rails"

require "interests/version"

module Interests
  class << self
    def table_name_prefix
      ""
    end
  end
end

require "interests/engine"
