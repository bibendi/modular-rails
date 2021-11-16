# frozen_string_literal: true

require "rails_helper"

describe AuthBy::ResetPasswordForm do
  let_it_be(:user, reload: true) { create :auth_user }

  let(:password) { "12345678" }
  let(:confirmation) { password }

  subject { described_class.new(user: user, password: password, password_confirmation: confirmation) }

  it "sets a password" do
    expect(subject.save).to be true
    expect(subject.user.valid_password?("12345678")).to be true
  end

  context "when password is short" do
    let(:password) { "123" }

    specify do
      expect(subject.save).to be false
      expect(subject.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
    end
  end

  context "when confirmation is wrong" do
    let(:confirmation) { "87654321" }

    specify do
      expect(subject.save).to be false
      expect(subject.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
  end
end
