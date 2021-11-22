# frozen_string_literal: true

module CoreBy
  module SDK
    module Users
      module_function

      def create(email: nil)
        if (form = CoreBy::Users::CreateForm.new(email: email)).save
          Resonad.success form.user&.to_entity
        else
          Resonad.failure form.errors
        end
      end

      def find_by_id(id)
        User.kept.find_by(id: id)&.to_entity
      end

      def find_by_external_id(external_id)
        User.kept.find_by(external_id: external_id)&.to_entity
      end

      def find_by_email(email)
        User.kept.find_by_email(email)&.to_entity
      end

      def discard!(user_id)
        User.find(user_id).discard!
      end
    end
  end
end
