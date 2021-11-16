# frozen_string_literal: true

FactoryBot.define do
  factory :auth_user, parent: :user, class: "AuthBy::User"
end
