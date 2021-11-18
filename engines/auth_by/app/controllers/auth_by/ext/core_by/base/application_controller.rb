# frozen_string_literal: true

module AuthBy
  module Ext
    module CoreBy
      module Base
        module ApplicationController
          extend ActiveSupport::Concern

          included do
            include Authenticatable
          end
        end
      end
    end
  end
end
