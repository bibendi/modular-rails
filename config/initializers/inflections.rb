# frozen_string_literal: true

ActiveSupport::Inflector.inflections do |inflect|
  inflect.acronym "JWT"
  inflect.uncountable %w[auth]
end
