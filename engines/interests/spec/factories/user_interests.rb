# frozen_string_literal: true

FactoryBot.define do
  factory :user_interest, class: "Interests::UserInterest" do
    interest
    user_id { create(:user).id }
  end
end
