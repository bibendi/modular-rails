# frozen_string_literal: true

module AuthBy
  class RegisterUserForm < CoreBy::BaseForm
    attr_reader :user_form, :user

    attributes :email, :password, :password_confirmation

    validates :email, presence: true
    validates :password, length: {minimum: 8}, confirmation: true
    validate :validate_user

    after_save do
      Downstream.publish(
        AuthBy::Users::Registered.new(user: user)
      )
    end

    def initialize(params)
      @user_form = CoreBy::Users::CreateForm.new(email: params[:email])
      super
    end

    def persist!
      user_form.save!
      @user = user_form.user.becomes(User)
      user.change_password!(password)
    rescue ActiveRecord::RecordNotUnique
      errors.add(:base, "User already exists")
      false
    end

    private

    def validate_user
      return if user_form.valid?

      merge_errors!(user_form)
    end
  end
end
