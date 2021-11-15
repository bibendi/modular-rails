# frozen_string_literal: true

require "rails_helper"

describe CoreBy::User, :user do
  it "saves user factory" do
    user = build(:user)
    expect(user.save).to be true
  end

  it "validates an email" do
    user = build(:user, email: "bad-email")
    expect(user).to_not be_valid
    expect(user.errors.include?(:email)).to eq true
  end

  it "validates a phone" do
    user = build(:user, phone: "111")
    expect(user).to_not be_valid
    expect(user.errors.include?(:phone)).to eq true
  end

  it "validates a login" do
    user = build(:user, login: "bad..login")
    expect(user).to_not be_valid
    expect(user.errors.include?(:login)).to eq true
  end

  it "finds user by not formatted phone" do
    user = create(:user, phone: "+7 999 123 45 67")
    expect(described_class.find_by_phone("+7 (999) 123-45-67")).to eq user
  end

  it "finds user by email" do
    user = create(:user, email: "maX@mail.test")
    expect(described_class.find_by_email("MAX@mail.test")).to eq user
  end

  it "strips login" do
    user = build(:user, login: " ")
    expect(user.login).to be_nil
  end

  it "strips email" do
    user = build(:user, email: " ")
    expect(user.email).to be_nil
  end

  it "strips phone" do
    user = build(:user, phone: " ")
    expect(user.phone).to be_nil
  end
end
