# frozen_string_literal: true

require "rails_helper"

describe Interests::Interest do
  it "uses entity" do
    expect(build(:interest).to_entity).to be_instance_of(Interests::SDK::InterestEntity)
  end

  it "saves interest factory" do
    interest = build(:interest)
    expect(interest.save).to be true
  end
end
