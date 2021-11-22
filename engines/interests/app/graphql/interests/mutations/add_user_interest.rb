# frozen_string_literal: true

module Interests
  module Mutations
    class AddUserInterest < CoreBy::Schema::Mutation
      description <<~DESC
        Add interest to current user
      DESC

      class AddUserInterestInput < GraphQL::Schema::InputObject
        description "User interests input"

        argument :name, String, required: true
      end

      argument :input, AddUserInterestInput, required: true

      field :user, CoreBy::Types::User, null: true
      field :interest, Types::Interest, null: true
      field :errors, CoreBy::Types::ValidationErrors, null: true

      def resolve(input:)
        authorize! UserInterest, to: :create?

        form = Users::AddInterestForm.new(current_user, input.name)

        if form.save
          {
            user: current_user,
            interest: form.interest
          }
        else
          {errors: form.errors}
        end
      end
    end
  end
end
