# frozen_string_literal: true

module CoreBy
  module SDK
    module Users
      module_function

      def create(email: nil)
        if (form = CoreBy::Users::CreateForm.new(email: email)).save
          # May be better to implement a magic method? `ActiveRecord::Base.to_entity`
          Resonad.success Entities::User.new(form.user)
        else
          Resonad.failure form.errors
        end
      end

      def find_by_id(id)
        Entities::User.from(User.kept.find_by(id: id))
      end

      def find_by_external_id(external_id)
        Entities::User.from(User.kept.find_by(external_id: external_id))
      end

      def find_by_email(email)
        Entities::User.from(User.kept.find_by_email(email))
      end

      def discard!(user_id)
        User.find(user_id).discard!
      end
    end
  end
end
