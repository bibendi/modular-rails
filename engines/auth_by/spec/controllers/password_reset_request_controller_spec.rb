# frozen_string_literal: true

require "rails_helper"

describe AuthBy::PasswordResetRequestController do
  routes { AuthBy::Engine.routes }

  let_it_be(:user, reload: true) { create :auth_user }

  describe "#show" do
    subject { get :show }

    it { is_expected.to be_successful }
  end

  describe "#update" do
    subject { put :update, params: {email: email} }

    before { allow(AuthBy::ResetPasswordRequest).to receive(:call).and_call_original }

    context "when email is blank" do
      let(:email) { "" }

      it { is_expected.to be_successful }
      it { expect(AuthBy::ResetPasswordRequest).not_to have_received(:call) }
    end

    context "when email is valid" do
      let(:email) { user.email }

      specify "calls a service" do
        is_expected.to be_successful
        expect(AuthBy::ResetPasswordRequest).to have_received(:call).with(user)
      end
    end
  end
end
