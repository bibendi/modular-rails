# frozen_string_literal: true

module AuthBy
  module MutationRoot
    extend ActiveSupport::Concern

    included do
      field :sign_up, mutation: Mutations::SignUp
      field :sign_in, mutation: Mutations::SignIn
      field :sign_out, mutation: Mutations::SignOut
      field :refresh_token, mutation: Mutations::RefreshToken
    end
  end
end
