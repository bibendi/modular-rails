# frozen_string_literal: true

module AuthBy
  class RegisterUserForm < CoreBy::Base::Form
    attr_reader :user

    attributes :email, :password, :password_confirmation

    validates :email, presence: true
    validates :password, length: {minimum: 8}, confirmation: true

    after_save do
      Downstream.publish(
        AuthBy::Events::Users::Registered.new(user: user)
      )
    end

    def persist!
      result = CoreBy::SDK::Users.create(email: email)
      unless result.ok?
        merge_errors!(result.error)
        return false
      end

      @user = User.find(result.value.id)
      user.change_password!(password)
    rescue ActiveRecord::RecordNotUnique
      errors.add(:base, "User already exists")
      false
    end
  end
end
