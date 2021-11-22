# frozen_string_literal: true

require "rails_helper"

describe Interests::Users::AddInterestForm do
  let(:user) { create(:user).to_entity }
  let(:name) { "Sport" }

  subject { described_class.new(user, name) }

  let(:interest) { subject.interest }

  it "adds interest to user" do
    expect { subject.save }.to change(Interests::UserInterest.where(user_id: user.id), :count).by(1)
    expect(interest).to be_persisted
  end

  context "when interest already exists" do
    before { create :interest, name: name }

    it "adds interest to user" do
      expect { subject.save }.to change(Interests::UserInterest.where(user_id: user.id), :count).by(1)
    end

    it "doesn't create new interest" do
      expect { subject.save }.not_to change(Interests::Interest.where(name: name), :count)
    end
  end

  context "when user already has this interest" do
    before do
      create :user_interest, interest: create(:interest, name: name), user_id: user.id
    end

    it "doesn't add that interest to user" do
      expect { subject.save }.not_to change(Interests::UserInterest.where(user_id: user.id), :count)
    end

    it "returns errors" do
      expect(subject.save).to eq false
      expect(subject.errors.full_messages).to include("Interest has already been taken")
    end
  end
end
