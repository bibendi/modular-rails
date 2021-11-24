# frozen_string_literal: true

FactoryBot.define do
  factory :interest, class: "Interests::Interest" do
    name { Faker::Lorem.unique.word }
  end
end
