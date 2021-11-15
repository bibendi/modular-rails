# frozen_string_literal: true

module CoreBy
  module Api
    class JobStatusesController < BaseController
      def show
        render json: ActiveJob::Status.get(params.require(:id))
      end
    end
  end
end
