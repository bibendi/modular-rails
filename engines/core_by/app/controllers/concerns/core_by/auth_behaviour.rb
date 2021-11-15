# frozen_string_literal: true

module CoreBy
  # Base controller interface.
  # Must be included into ApplicationContoller (or other
  # parent controller used by engines' controllers)
  module AuthBehaviour
    private

    def authenticate!
      not_authenticated unless current_user
    end
  end
end
