# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "CoreBy::User" do
    sequence(:login) { |n| Faker::Internet.unique.username(specifier: 3..32, separators: %w[.]) }
    sequence(:phone) { |n| "+79991#{n}".ljust(12, "123456") }
    sequence(:email) { |n| Faker::Internet.email.sub("@", "-#{n}@") }

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { "member" }
    membership_state { "active" }

    trait :admin do
      role { "admin" }
    end

    trait :manager do
      role { "manager" }
    end

    trait :member do
      role { "member" }
    end

    trait :active do
      membership_state { "active" }
    end

    trait :disabled do
      membership_state { "disabled" }
    end

    trait :deleted do
      deleted_at { Time.current }
    end

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(File.join(__dir__, "../fixtures/files/avatar.jpg"), "image/jpeg") }
    end

    trait :randomize_phone do
      phone { "+79991#{rand(10**5)}".ljust(12, "123456") }
    end
  end

  factory :admin, parent: :user, traits: [:admin]
  factory :manager, parent: :user, traits: [:manager]
  factory :member, parent: :user, traits: [:member]
end
