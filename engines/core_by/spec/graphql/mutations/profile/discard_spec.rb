# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Mutations::Profile::Discard do
  let(:query) do
    <<~GRAPHQL
      mutation DiscardProfile {
        discardProfile {
          user {
            discarded
          }
        }
      }
    GRAPHQL
  end

  include_examples "field is not accessible to unauthenticated users", "discardProfile"

  it "discard current user" do
    subject

    expect(data["user"]["discarded"]).to be true
  end
end
