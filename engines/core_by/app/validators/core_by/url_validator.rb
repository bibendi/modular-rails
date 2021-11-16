# frozen_string_literal: true

module CoreBy
  class URLValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      return if URI::DEFAULT_PARSER.make_regexp.match?(value)

      object.errors.add(
        attribute,
        options[:message] || :invalid_url
      )
    end
  end
end
