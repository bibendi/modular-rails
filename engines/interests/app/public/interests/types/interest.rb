# frozen_string_literal: true

module Interests
  module Types
    class Interest < CoreBy::Schema::Object
      description "Represents interest record"

      field :id, ID, null: false
      field :name, String, null: false
    end
  end
end
