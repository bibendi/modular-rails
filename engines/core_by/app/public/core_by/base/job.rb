# frozen_string_literal: true

module CoreBy
  module Base
    class Job < ActiveJob::Base
      class << self
        def track_status
          include ActiveJob::Status
        end
      end
    end
  end
end
