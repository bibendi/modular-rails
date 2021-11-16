# frozen_string_literal: true

require "rails_helper"

describe AuthBy::Mutations::RefreshToken do
  let_it_be(:user, reload: true) { create(:auth_user) }

  let(:query) do
    <<~GRAPHQL
      mutation refreshToken($refreshToken: String!) {
        refreshToken(refreshToken: $refreshToken) { accessToken }
      }
    GRAPHQL
  end

  let(:variables) { {refresh_token: tokens[:refresh]} }

  context "when refresh token is invalid" do
    let(:tokens) { {refresh: "wrong-token"} }

    it { expect(errors[0]).to eq "Malicious activity detected" }
  end

  context "user access token is still valid" do
    let(:tokens) { user.generate_jwt_tokens }

    it "returns a new access token" do
      expect(data["accessToken"]).to be_a(String)
      expect(JWTSessions::Session.new.session_exists?(data["accessToken"], "access")).to be true
      expect(JWTSessions::Session.new.session_exists?(tokens[:access], "access")).to be false
      expect(JWTSessions::Session.new.session_exists?(tokens[:refresh], "refresh")).to be true
    end

    context "when user is discarded" do
      before { user.discard! }

      it { expect(errors[0]).to eq "Unauthenticated access to the field refreshToken" }
      it { expect(reasons[0]).to eq :user_not_found }
    end
  end

  context "user access token is expired" do
    let(:tokens) do
      prev_exp = JWTSessions.access_exp_time
      JWTSessions.access_exp_time = 0
      tokens = user.generate_jwt_tokens
      JWTSessions.access_exp_time = prev_exp
      tokens
    end

    it "returns a new access token" do
      expect(data["accessToken"]).to be_a(String)
      expect(JWTSessions::Session.new.session_exists?(data["accessToken"], "access")).to be true
      expect(JWTSessions::Session.new.session_exists?(tokens[:access], "access")).to be false
      expect(JWTSessions::Session.new.session_exists?(tokens[:refresh], "refresh")).to be true
    end
  end

  context "user refresh token is expired" do
    let(:tokens) do
      prev_exp = JWTSessions.refresh_exp_time
      JWTSessions.refresh_exp_time = 0
      tokens = user.generate_jwt_tokens
      JWTSessions.refresh_exp_time = prev_exp
      tokens
    end

    it { expect(errors[0]).to eq "Refresh token is expired" }
  end
end
