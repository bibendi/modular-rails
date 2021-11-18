# frozen_string_literal: true

module AuthBy
  class PasswordResetController < CoreBy::Base::ApplicationController
    layout Engine.config.layout if Engine.config.respond_to?(:layout)

    before_action :redirect_authenticated
    before_action :load_user

    def show
    end

    def update
      form = ResetPasswordForm.new(
        user: @user,
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )

      if form.save
        redirect_to main_app.root_path, notice: "Password has been updated successfully"
      else
        flash.now[:alert] = form.errors.full_messages.join("\n")
        render :show, status: 422
      end
    end

    private

    def load_user
      return not_authenticated if params[:token].blank?
      @user = User.load_from_reset_password_token(params[:token])

      not_authenticated unless @user
    end
  end
end
