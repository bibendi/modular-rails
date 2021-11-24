# frozen_string_literal: true

module Interests
  module SDK
    module Types
      class Interest < CoreBy::SDK::Schema::Object
        description "Represents interest record"

        field :id, ID, null: false
        field :name, String, null: false
      end
    end
  end
end
