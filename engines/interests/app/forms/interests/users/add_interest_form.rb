# frozen_string_literal: true

module Interests
  module Users
    class AddInterestForm < CoreBy::Base::Form
      attr_reader :user, :name, :interest

      validates :name, presence: true

      def initialize(user, name)
        @user = user
        @name = name
      end

      def persist!
        @interest = Interest.find_or_initialize_by(name: name)

        unless interest.save
          merge_errors!(interest.errors)
          return false
        end

        user_interest = UserInterest.new(interest: interest, user_id: user.id)
        return if user_interest.save

        merge_errors!(user_interest.errors)
        false
      end
    end
  end
end
