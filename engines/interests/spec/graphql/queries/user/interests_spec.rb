# frozen_string_literal: true

require "rails_helper"

describe "query { user { interests { ... } } }" do
  let_it_be(:interest_a) { create :interest, name: "Sport" }
  let_it_be(:interest_b) { create :interest, name: "Music" }
  let_it_be(:interest_c) { create :interest, name: "Travel" }

  before_all do
    create :user_interest, interest: interest_a, user_id: user.id
    create :user_interest, interest: interest_b, user_id: user.id
  end

  let(:query) do
    <<~GRAPHQL
      query UserInterests($userId: ID!) {
        member(id: $userId) {
          interests {
            nodes {
              id
              name
            }
          }
        }
      }
    GRAPHQL
  end

  let(:variables) { {user_id: user.external_id} }
  let(:field) { "member->interests->nodes" }

  it "returns interests ordered by name" do
    expect(data[0]["name"]).to eq "Music"
    expect(data[1]["name"]).to eq "Sport"
  end
end
