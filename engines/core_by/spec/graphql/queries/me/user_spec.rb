# frozen_string_literal: true

require "rails_helper"

describe "{ me { user { ... } } }" do
  let(:query) do
    <<~GRAPHQL
      query getCurrentUser {
        me {
          user {
            id
            login
            name
            firstName
            lastName
            role
            phone
            email
            myself
          }
        }
      }
    GRAPHQL
  end

  let(:field) { "me->user" }

  include_examples "field is not accessible to unauthenticated users", "me"

  it "returns current user data", :aggregate_failures do
    expect(data.fetch("id")).to eq user.external_id
    expect(data.fetch("firstName")).to eq "James"
    expect(data.fetch("lastName")).to eq "Black"
    expect(data.fetch("role")).to eq "MEMBER"
    expect(data.fetch("myself")).to be true
    expect(data.fetch("phone")).to eq user.phone
    expect(data.fetch("login")).to eq user.login
    expect(data.fetch("email")).to eq user.email
  end

  context "when I'm manager" do
    let(:user) { create(:manager, name: "Evil Cat") }

    it "returns manager's data", :aggregate_failures do
      expect(data.fetch("firstName")).to eq "Evil"
      expect(data.fetch("lastName")).to eq "Cat"
      expect(data.fetch("role")).to eq "ADMIN"
    end
  end

  context "with avatar" do
    let_it_be(:user) { create(:member, :with_avatar) }

    let(:query) do
      <<~GRAPHQL
        query getCurrentUser {
          me {
            user {
              avatarUrl(variant: basic)
            }
          }
        }
      GRAPHQL
    end

    it "returns current user avatar url" do
      expect(data.fetch("avatarUrl")).to start_with("http://imgproxy/")
    end
  end
end
