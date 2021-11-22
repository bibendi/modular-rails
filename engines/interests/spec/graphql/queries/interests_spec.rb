# frozen_string_literal: true

require "rails_helper"

describe "query { interests { ... } }" do
  let_it_be(:interest_a) { create :interest, name: "Sport" }
  let_it_be(:interest_b) { create :interest, name: "Music" }
  let_it_be(:interest_c) { create :interest, name: "Travel" }

  let(:query) do
    <<~GRAPHQL
      query interests($first: Int) {
        interests(first: $first) {
          nodes {
            id
            name
          }
        }
      }
    GRAPHQL
  end

  let(:variables) { {first: 2} }

  it "returns interests ordered by name" do
    expect(data["nodes"][0]["name"]).to eq "Music"
    expect(data["nodes"][1]["name"]).to eq "Sport"
  end
end
