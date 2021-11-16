# frozen_string_literal: true

require "rails_helper"

describe AuthBy::Mutations::SignUp do
  let(:query) do
    <<~GRAPHQL
      mutation signUp($input: SignUpInput!) {
        signUp(input: $input) {
          accessToken
          refreshToken
          user {
            id
          }
          errors {
            fullMessages
            details
          }
        }
      }
    GRAPHQL
  end

  let(:variables) { {input: {email: "user@example.com", password: "12345678", password_confirmation: "12345678"}} }

  it "registers user" do
    expect(data["accessToken"]).to be_a(String)
    expect(data["refreshToken"]).to be_a(String)
    expect(JWTSessions::Session.new.session_exists?(data["accessToken"], "access")).to be true
    expect(data.dig("user", "id")).to be_present
  end

  context "when have any errors" do
    before { variables[:input][:email] = "" }

    it "returns errors" do
      expect(data["accessToken"]).to be_nil
      expect(data["refreshToken"]).to be_nil
      expect(data["user"]).to be_nil
      expect(data.dig("errors", "fullMessages")).to include("Email can't be blank")
    end
  end
end
