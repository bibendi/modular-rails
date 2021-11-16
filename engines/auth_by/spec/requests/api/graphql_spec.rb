# frozen_string_literal: true

require "rails_helper"

describe "/api/graphql" do
  let_it_be(:user, refind: true) { create(:auth_user, password: "qwerty") }

  let(:request) { post "/api/graphql.json", params: params, headers: headers }
  let(:params) { {query: query} }
  let(:query) do
    <<~GRAPHQL
      {
        me {
          user { id }
        }
      }
    GRAPHQL
  end

  context "when user is authenticated" do
    let(:jwt_token) { user.generate_jwt_tokens[:access] }
    let(:headers) { {JWTSessions.access_header => jwt_token} }

    before { jwt_token }

    it "works" do
      is_expected.to be_successful
      expect(json_response.dig("data", "me", "user", "id")).to eq user.external_id
    end

    context "when user is disabled" do
      before { user.update!(membership_state: :disabled) }

      it "doesn't authenticate user", :aggregate_failures do
        is_expected.to be_successful
        expect(json_response.dig("data", "me")).to be nil
        expect(json_response["errors"][0]["extensions"]["code"]).to eq "unauthenticated"
        expect(json_response["errors"][0]["extensions"]["reason"]).to eq "user_not_found"
      end
    end

    context "when user is discarded" do
      before { user.discard }

      it "authenticates user" do
        is_expected.to be_successful
        expect(json_response.dig("data", "me", "user", "id")).to eq user.external_id
      end
    end

    context "when user is destroyed" do
      before { user.really_destroy }

      it "doesn't authenticate user", :aggregate_failures do
        is_expected.to be_successful
        expect(json_response.dig("data", "me")).to be nil
        expect(json_response["errors"][0]["extensions"]["code"]).to eq "unauthenticated"
        expect(json_response["errors"][0]["extensions"]["reason"]).to eq "user_not_found"
      end
    end
  end

  context "when user is unauthenticated" do
    context "missing token" do
      let(:headers) { {} }

      it "responds with :invalid reason", :aggregate_failures do
        is_expected.to be_successful
        expect(json_response.fetch("errors").first.fetch("message")).to eq "Unauthenticated access to the field me"
        expect(json_response.fetch("errors").first.dig("extensions", "code")).to eq "unauthenticated"
      end
    end

    context "invalid token" do
      let(:headers) { {JWTSessions.access_header => "asdasdasdsasdda"} }

      it "responds with :invalid reason", :aggregate_failures do
        is_expected.to be_successful
        expect(json_response.fetch("errors").first.fetch("message")).to eq "Unauthenticated access"
        expect(json_response.fetch("errors").first.dig("extensions", "code")).to eq "unauthenticated"
        expect(json_response.fetch("errors").first.dig("extensions", "reason")).to eq "token_invalid"
      end
    end

    context "expired token" do
      let(:jwt_token) do
        # set expiration time to 0 to create an already expired access token
        JWTSessions.access_exp_time = 0
        token = user.generate_jwt_tokens[:access]
        JWTSessions.access_exp_time = 3600
        token
      end
      let(:headers) { {JWTSessions.access_header => jwt_token} }

      it "responds with :expired reason", :aggregate_failures do
        is_expected.to be_successful
        expect(json_response.fetch("errors").first.fetch("message")).to eq "Unauthenticated access"
        expect(json_response.fetch("errors").first.dig("extensions", "code")).to eq "unauthenticated"
        expect(json_response.fetch("errors").first.dig("extensions", "reason")).to eq "token_expired"
      end
    end
  end
end
