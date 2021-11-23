# frozen_string_literal: true

require "rails_helper"

describe Interests::SDK::UserInterestsRepository do
  let_it_be(:interest_a) { create :interest, name: "Sport" }
  let_it_be(:interest_b) { create :interest, name: "Music" }
  let_it_be(:interest_c) { create :interest, name: "Travel" }

  describe ".fetch" do
    let_it_be(:user) { create :user }

    before do
      create :user_interest, interest: interest_a, user_id: user.id
      create :user_interest, interest: interest_c, user_id: user.id
    end

    subject { described_class.fetch(user.id) }

    it "returns user's interests" do
      expect(subject.size).to eq 2
      expect(subject.first).to eq interest_a.to_entity
      expect(subject.last).to eq interest_c.to_entity
    end
  end
end
