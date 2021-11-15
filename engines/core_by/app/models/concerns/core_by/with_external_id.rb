# frozen_string_literal: true

require "securerandom"

module CoreBy
  module WithExternalId
    extend ActiveSupport::Concern

    included do
      before_validation(on: :create) { self.external_id ||= SecureRandom.uuid }

      validates :external_id, presence: true
    end
  end
end
