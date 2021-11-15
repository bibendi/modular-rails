# frozen_string_literal: true

module CoreBy
  class BaseJob < ActiveJob::Base
    class << self
      def track_status
        include ActiveJob::Status
      end
    end
  end
end
