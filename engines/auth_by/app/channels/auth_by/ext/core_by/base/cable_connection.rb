# frozen_string_literal: true

module AuthBy
  module Ext
    module CoreBy
      module Base
        module CableConnection
          extend ActiveSupport::Concern

          included do
            prepend Override
          end

          module Override
            def connect
              begin
                self.current_user = jwt_auth.current_user
              rescue JwtAuth::ExpiredToken
                AnyCable.logger.info("JWT token is expired")
              rescue JwtAuth::InvalidToken
                AnyCable.logger.info("JWT token is invalid")
              end

              super
            end
          end

          private

          def jwt_auth
            @jwt_auth ||= JwtAuth.new(request)
          end
        end
      end
    end
  end
end
