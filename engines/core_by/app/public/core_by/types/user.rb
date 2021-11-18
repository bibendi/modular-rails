# frozen_string_literal: true

module CoreBy
  module Types
    class User < Schema::Object
      description "Represents user record"

      field :id, ID, null: false, method: :external_id
      field :login, String, null: true
      field :name, String, null: true
      field :first_name, String, null: true
      field :last_name, String, null: true
      field :membership_state, Enums::MembershipState, null: false
      field :phone, String, "User's phone number (available only for admins and himself)", null: true
      field :email, String, "User's email (available only for admins and himself)", null: true
      field :role, Enums::Role, "User's role (admin or member)", null: false
      field :discarded, Boolean, "True for deleted users", null: false, method: :discarded?
      field :myself, Boolean, "Whether this user is the current user", null: false
      field :avatar_url, Types::URLString, "URL of user's avatar", null: true do
        extension Schema::FieldExtensions::AttachmentURLField, variant: {enum: Enums::AvatarVariant, required: true}
      end

      def role
        # clients don't care about manager vs admin difference
        return "admin" if object.admin? || object.manager?
        object.role
      end

      def myself
        return false unless current_user
        object.id == current_user.id
      end

      def email
        object.email if allowed_to?(:contacts?, object)
      end

      def phone
        object.phone if allowed_to?(:contacts?, object)
      end
    end

    ActiveSupport.run_load_hooks("core_by/types/user", User)
  end
end
