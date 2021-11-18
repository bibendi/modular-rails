# frozen_string_literal: true

module AuthBy
  module Ext
    module CoreBy
      module Base
        module ApiController
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
