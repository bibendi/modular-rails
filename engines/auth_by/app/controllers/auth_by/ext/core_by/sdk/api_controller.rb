# frozen_string_literal: true

module AuthBy
  module Ext
    module CoreBy
      module SDK
        module APIController
          extend ActiveSupport::Concern

          included do
            # Support session-cookie-based authentication
            include ActionController::Cookies

            include Authenticatable
          end
        end
      end
    end
  end
end
