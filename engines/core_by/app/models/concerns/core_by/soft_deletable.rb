# frozen_string_literal: true

# Provides soft-delete functionality
# based on https://github.com/jhawthorn/discard
module CoreBy
  module SoftDeletable
    extend ActiveSupport::Concern
    include Discard::Model

    DESTROY_PROHIBITED_ERROR = "Using #destroy on soft-deletable models is prohibited. " \
                               "Use #really_destroy if you really need it"

    included do
      class_attribute :discard_column
      self.discard_column = :deleted_at

      alias_method :really_destroy, :destroy

      def destroy
        destroyed_by_association.present? ?
          discard : raise(DESTROY_PROHIBITED_ERROR)
      end

      def destroy!
        destroy
      end

      def really_destroy!
        really_destroy || _raise_record_not_destroyed
      end
    end
  end
end
