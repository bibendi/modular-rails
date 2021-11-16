# frozen_string_literal: true

require "rails_helper"

describe AuthBy::Mutations::SignIn do
  let_it_be(:user, reload: true) { create(:auth_user, email: "user@example.com", password: "qwerty") }

  let(:query) do
    <<~GRAPHQL
      mutation signIn($input: SignInInput!) {
        signIn(input: $input) {
          accessToken
          refreshToken
        }
      }
    GRAPHQL
  end

  let(:variables) { {input: {email: "user@example.com", password: "qwerty"}} }

  it "generates JWT tokens" do
    expect(JWTSessions::Session.new.session_exists?(data["accessToken"], "access")).to be true
    expect(JWTSessions::Session.new.session_exists?(data["refreshToken"], "refresh")).to be true
  end

  context "when email is invalid" do
    let(:variables) { {input: {email: "invalid@example.com", password: "qwerty"}} }

    it "responds with an error" do
      expect(errors[0]).to eq "Unauthenticated"
    end
  end

  context "when password is invalid" do
    let(:variables) { {input: {email: "user@example.com", password: "invalid"}} }

    it "responds with an error" do
      expect(errors[0]).to eq "Unauthenticated"
    end
  end

  context "when user is discarded" do
    it "generates JWT tokens" do
      expect(JWTSessions::Session.new.session_exists?(data["accessToken"], "access")).to be true
      expect(JWTSessions::Session.new.session_exists?(data["refreshToken"], "refresh")).to be true
    end
  end

  context "when user is disabled" do
    it "responds with an error" do
      user.update!(membership_state: :disabled)
      expect(errors[0]).to eq "Unauthenticated"
    end
  end
end
