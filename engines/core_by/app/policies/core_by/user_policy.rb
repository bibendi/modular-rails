# frozen_string_literal: true

module CoreBy
  class UserPolicy < Base::Policy
    pre_check :allow_community_managers

    alias_rule :view?, to: :show?

    def show?
      !record.community_manager? && record.active?
    end

    def manage?
      myself?
    end

    def contacts?
      myself?
    end

    private

    def myself?
      record && record.id == user&.id
    end
  end
end
