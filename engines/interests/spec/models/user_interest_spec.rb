# frozen_string_literal: true

require "rails_helper"

describe Interests::UserInterest do
  it "saves user_interest factory" do
    user_interest = build(:user_interest)
    expect(user_interest.save).to be true
  end
end
