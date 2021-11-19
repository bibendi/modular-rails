# frozen_string_literal: true

module CoreBy
  module Entities
    class User < Base::Entity
      delegate_attrs :id,
        :external_id,
        :login,
        :name,
        :first_name,
        :last_name,
        :membership_state,
        :email,
        :phone,
        :role,
        :discarded?,
        :disabled?
    end
  end
end
