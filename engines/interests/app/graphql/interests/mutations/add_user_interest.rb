# frozen_string_literal: true

module Interests
  module Mutations
    class AddUserInterest < CoreBy::SDK::Schema::Mutation
      description <<~DESC
        Add interest to current user
      DESC

      class AddUserInterestInput < CoreBy::SDK::Schema::Input
        description "User interests input"

        argument :name, String, required: true
      end

      argument :input, AddUserInterestInput, required: true

      field :user, CoreBy::SDK::Types::User, null: true
      field :interest, SDK::Types::Interest, null: true
      field :errors, CoreBy::SDK::Types::ValidationErrors, null: true

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
