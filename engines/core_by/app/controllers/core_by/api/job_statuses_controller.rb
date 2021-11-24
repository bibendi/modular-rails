# frozen_string_literal: true

module CoreBy
  module API
    class JobStatusesController < SDK::ApplicationController
      def show
        render json: ActiveJob::Status.get(params.require(:id))
      end
    end
  end
end
