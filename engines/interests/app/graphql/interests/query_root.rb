# frozen_string_literal: true

module Interests
  module QueryRoot
    extend ActiveSupport::Concern

    included do
      field :interests, Types::Interest.connection_type, "Returns all known interests", null: false
    end

    def interests
      Interests::Interest.ordered
    end
  end
end
