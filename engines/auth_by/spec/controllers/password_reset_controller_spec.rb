# frozen_string_literal: true

require "rails_helper"

describe AuthBy::PasswordResetController do
  routes { AuthBy::Engine.routes }

  let_it_be(:user, reload: true) { create :auth_user }

  describe "#show" do
    subject { get :show, params: {token: token} }

    context "when token is blank" do
      let(:token) { " " }

      it { is_expected.to redirect_to("/") }
    end

    context "when token is valid" do
      let(:token) { user.tap { |u| u.generate_reset_password_token! }.reset_password_token }

      it { is_expected.to be_successful }
    end
  end

  describe "#update" do
    context "when token is blank" do
      subject { put :update, params: {token: " "} }

      it { is_expected.to redirect_to("/") }
    end

    context "when token is valid" do
      let(:token) { user.tap { |u| u.generate_reset_password_token! }.reset_password_token }

      subject { put :update, params: {token: token, password: pass, password_confirmation: pass} }

      context "when password is blank" do
        let(:pass) { "" }

        it { is_expected.to be_unprocessable }
      end

      context "when password is valid" do
        let(:pass) { "qwertyqwerty" }

        it { is_expected.to redirect_to("/") }
      end
    end
  end
end
