# frozen_string_literal: true

module AuthBy
  module Api
    module BaseController
      extend ActiveSupport::Concern

      included do
        # Support session-cookie-based authentication
        include ActionController::Cookies

        include Authenticatable
      end
    end
  end
end
