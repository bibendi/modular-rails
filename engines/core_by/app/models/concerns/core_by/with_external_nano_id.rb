# frozen_string_literal: true

module CoreBy
  module WithExternalNanoId
    extend ActiveSupport::Concern

    included do
      before_validation(on: :create) { self.external_id ||= Nanoid.generate(size: 12) }

      validates :external_id, presence: true
    end
  end
end
