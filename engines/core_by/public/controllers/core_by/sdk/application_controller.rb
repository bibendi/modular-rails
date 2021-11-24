# frozen_string_literal: true

module CoreBy
  module SDK
    class ApplicationController < ActionController::Base
      include AuthBehaviour

      # Make Active Storage know about the current url host
      # (used by direct uploads)
      include ::ActiveStorage::SetCurrent

      protect_from_forgery with: :exception

      before_action :set_paper_trail_whodunnit

      private

      helper_method def attachment_url(...)
        CoreBy::ActiveStorage.attachment_url(...)
      end

      def not_authenticated
        respond_to do |format|
          format.json do
            render json: {error: "Not authenticated"}, status: 401
          end
          format.html { redirect_not_authenticated }
        end
      end

      def not_authorized
        respond_to do |format|
          format.json do
            render json: {error: "Not authorized"}, status: 403
          end
          format.html { redirect_not_authorized }
        end
      end

      def redirect_not_authenticated
        redirect_to main_app.root_path, alert: "Not authenticated"
      end

      def redirect_not_authorized
        redirect_to main_app.root_path, alert: "Not authorized"
      end

      def redirect_authenticated
        return unless current_user

        redirect_to main_app.root_path, alert: "Already authenticated"
      end
    end

    ActiveSupport.run_load_hooks("core_by/sdk/application_controller", ApplicationController)

    unless ApplicationController.instance_methods.include?(:current_user)
      class ApplicationController
        attr_accessor :current_user
      end
    end
  end
end
