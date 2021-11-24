# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Users::CreateForm do
  let(:params) do
    {
      phone: "+7 (999) 123-45-67"
    }
  end

  subject { described_class.new(params) }

  let(:user) { subject.user }

  it "creates a user", :aggregate_failures do
    expect(subject.save).to be true
    expect(user.phone).to eq "+79991234567"
  end

  it "publishes event" do
    expect { subject.save }.to have_published_event(CoreBy::SDK::Users::Created)
  end
end
