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
    expect { subject.save }.to have_published_event(CoreBy::Users::Created)
  end

  context "when phone is invalid" do
    before { params[:phone] = "000123" }

    it { expect(subject.save).to be false }
    it { expect { subject.save }.not_to have_published_event(CoreBy::Users::Created) }
  end

  context "when phone is not provided" do
    before { params.delete(:phone) }

    it { expect(subject.save).to be false }
    it { expect { subject.save }.not_to have_published_event(CoreBy::Users::Created) }
  end
end
