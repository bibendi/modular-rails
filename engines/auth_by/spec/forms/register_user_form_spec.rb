# frozen_string_literal: true

require "rails_helper"

describe AuthBy::RegisterUserForm do
  let(:email) { "user@example.com" }
  let(:password) { "12345678" }
  let(:confirmation) { password }

  subject { described_class.new(email: email, password: password, password_confirmation: confirmation) }

  it "creates a user" do
    expect(subject.save).to be true
    expect(subject.user.email).to eq email
    expect(subject.user.valid_password?(password)).to be true
  end

  it "publishes event" do
    expect { subject.save }.to have_published_event(AuthBy::SDK::Users::Registered)
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

  context "when user already exists" do
    before { create :user, email: email }

    specify do
      expect(subject.save).to be false
      expect(subject.errors.full_messages).to include("Email has already been taken")
    end
  end
end
