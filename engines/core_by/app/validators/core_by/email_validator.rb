# frozen_string_literal: true

module CoreBy
  class EmailValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      return if URI::MailTo::EMAIL_REGEXP.match?(value)

      object.errors.add(
        attribute,
        options[:message] || :invalid_email
      )
    end
  end
end
