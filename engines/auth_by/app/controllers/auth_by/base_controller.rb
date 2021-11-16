# frozen_string_literal: true

module AuthBy
  module BaseController
    extend ActiveSupport::Concern

    included do
      include Authenticatable
    end
  end
end
