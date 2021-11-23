# frozen_string_literal: true

module Interests
  module QueryRoot
    extend ActiveSupport::Concern

    included do
      field :interests, SDK::Types::Interest.connection_type, "Returns all known interests", null: false
    end

    def interests
      Interest.ordered
    end
  end
end
