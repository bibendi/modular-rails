# frozen_string_literal: true

module CoreBy
  module SDK
    class ApplicationJob < ActiveJob::Base
      class << self
        def track_status
          include ActiveJob::Status
        end
      end
    end
  end
end
