# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Mutations::Profile::UpdateInfo do
  let(:query) do
    <<~GRAPHQL
      mutation updateProfile($input: UpdateProfileInfoInput!) {
        updateProfileInfo(input: $input) {
          user {
            login
            name
            firstName
            lastName
          }
          errors {
            fullMessages
            details
          }
        }
      }
    GRAPHQL
  end

  let(:variables) do
    {
      input: {
        login: "green",
        name: "John Green"
      }
    }
  end

  include_examples "field is not accessible to unauthenticated users", "updateProfileInfo"

  it "updates current user's info" do
    expect { subject }.to change { user.reload.name }.to("John Green")

    expect(data.fetch("user").fetch("login")).to eq "green"
    expect(data.fetch("user").fetch("name")).to eq "John Green"
    expect(data.fetch("user").fetch("firstName")).to eq "John"
    expect(data.fetch("user").fetch("lastName")).to eq "Green"
  end

  context "when validation failed" do
    let(:variables) { {input: {login: ""}} }

    it "returns errors" do
      expect(data.fetch("errors").fetch("fullMessages")).to include("Login can't be blank")
    end
  end
end
