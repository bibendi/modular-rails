# frozen_string_literal: true

require "rails_helper"

describe AuthBy::Mutations::SignOut do
  let_it_be(:user, reload: true) { create(:auth_user) }

  let(:query) do
    <<~GRAPHQL
      mutation signOut($refreshToken: String!) {
        signOut(refreshToken: $refreshToken) { userId }
      }
    GRAPHQL
  end

  let(:variables) { {refresh_token: tokens[:refresh]} }

  context "when token is valid" do
    let(:tokens) { user.generate_jwt_tokens }

    it "flushes the token" do
      expect(data["userId"]).to eq user.id
      expect(JWTSessions::Session.new.session_exists?(tokens[:access], "access")).to be false
      expect(JWTSessions::Session.new.session_exists?(tokens[:refresh], "refresh")).to be false
    end
  end

  context "when token is expired" do
    let(:tokens) do
      prev_exp = JWTSessions.access_exp_time
      JWTSessions.access_exp_time = 0
      tokens = user.generate_jwt_tokens
      JWTSessions.access_exp_time = prev_exp
      tokens
    end

    it "flushes the token" do
      expect(data["userId"]).to eq user.id
      expect(JWTSessions::Session.new.session_exists?(tokens[:access], "access")).to be false
      expect(JWTSessions::Session.new.session_exists?(tokens[:refresh], "refresh")).to be false
    end
  end

  context "when token is invalid" do
    let(:tokens) { {refresh: "wrong-token"} }

    it { expect(errors[0]).to eq "Malicious activity detected" }
  end
end
