# frozen_string_literal: true

module Interests
  module Entities
    class Interest < CoreBy::Base::Entity
      delegate_attrs :id, :name
    end
  end
end
