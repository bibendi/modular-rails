# frozen_string_literal: true

module CoreBy
  module Recurring
    # https://github.com/paper-trail-gem/paper_trail#3d-deleting-old-versions
    class CleanVersionsTableJob < BaseJob
      queue_as :low_priority

      def perform
        with_lock do
          PaperTrail::Version
            .where("created_at < ?", 1.month.ago)
            .delete_all
        end
      end
    end
  end
end
