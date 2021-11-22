# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Events::Users::OnCreated::AddDefaultInterest do
  let_it_be(:interest) { create :interest, name: "Sport" }
  let_it_be(:user) { create :user }

  let(:event) { CoreBy::Events::Users::Created.new(user: user) }

  subject { Downstream.publish(event) }

  it "add default interest to user" do
    expect { subject }.to change(Interests::UserInterest.where(interest: interest, user_id: user.id), :count).by(1)
  end
end
