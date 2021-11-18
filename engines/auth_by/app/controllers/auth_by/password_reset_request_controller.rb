# frozen_string_literal: true

module AuthBy
  class PasswordResetRequestController < CoreBy::Base::ApplicationController
    layout Engine.config.layout if Engine.config.respond_to?(:layout)

    before_action :redirect_authenticated

    def show
    end

    def update
      user = User.find_by_email(params[:email])

      # Make response look like successful to not expose real users emails
      ResetPasswordRequest.call(user) if user

      render :requested
    end
  end
end
