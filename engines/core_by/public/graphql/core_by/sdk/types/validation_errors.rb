# frozen_string_literal: true

module CoreBy
  module SDK
    module Types
      class ValidationErrors < Schema::Object
        description <<~DESC
          Represents form validation errors
          (wrapper over ActiveModel::Errors
          https://api.rubyonrails.org/classes/ActiveModel/Errors.html)
        DESC

        field :full_messages, [String], "Human-friendly error messages", null: false
        field :details, JSONString, "JSON-encoded map of attribute -> error ids", null: false
      end
    end
  end
end
