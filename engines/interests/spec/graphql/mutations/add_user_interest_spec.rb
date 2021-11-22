# frozen_string_literal: true

require "rails_helper"

describe Interests::Mutations::AddUserInterest do
  let(:query) do
    <<~GRAPHQL
      mutation addUserInterest($input: AddUserInterestInput!) {
        addUserInterest(input: $input) {
          user {
            id
          }
          interest {
            id
            name
          }
          errors {
            fullMessages
            details
          }
        }
      }
    GRAPHQL
  end

  let(:variables) { {input: {name: "Sport"}} }

  include_examples "field is not accessible to unauthenticated users", "addUserInterest"

  it "is authorized" do
    expect { subject }.to be_authorized_to(:create?, Interests::UserInterest)
      .with(Interests::UserInterestPolicy)
  end

  it "adds interest to user" do
    expect { subject }.to change(Interests::UserInterest.where(user_id: user.id), :count).by(1)
    expect(data.dig("interest", "id")).to be_present
    expect(data.dig("interest", "name")).to eq "Sport"
  end

  context "when user already has that interest" do
    before do
      create :user_interest, interest: create(:interest, name: "Sport"), user_id: user.id
    end

    it "returns errors" do
      expect { subject }.not_to change(Interests::UserInterest.where(user_id: user.id), :count)

      expect(data["errors"]["fullMessages"]).to include("Interest has already been taken")
    end
  end
end
