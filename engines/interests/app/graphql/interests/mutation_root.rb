# frozen_string_literal: true

module Interests
  module MutationRoot
    extend ActiveSupport::Concern

    included do
      with_options authenticate: true do
        field :add_user_interest, mutation: Mutations::AddUserInterest
      end
    end
  end
end
