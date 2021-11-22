# frozen_string_literal: true

require "rails_helper"

describe Interests::Interest do
  xit "uses entity" do
    expect(build(:interest).to_entity).to be_instance_of(Interests::Entities::Interest)
  end

  it "saves interest factory" do
    interest = build(:interest)
    expect(interest.save).to be true
  end
end
