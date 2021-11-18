# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Users::UpdateForm do
  let_it_be(:user, reload: true) { create :user }

  let(:params) do
    {
      login: "bob",
      name: "Bob Dod"
    }
  end

  subject { described_class.new(user, params).save }

  it "updates a user", :aggregate_failures do
    subject

    expect(user.login).to eq "bob"
    expect(user.name).to eq "Bob Dod"
  end

  it "publishes event" do
    expect { subject }.to have_published_event(CoreBy::Events::Users::Updated)
      .with(
        user: user,
        changed_fields: a_collection_including("login", "first_name", "last_name")
      )
  end

  context "when login is empty" do
    before { params[:login] = nil }

    it { is_expected.to be false }
    it { expect { subject }.not_to have_published_event(CoreBy::Events::Users::Updated) }
  end

  context "when login is not provided" do
    before { params.delete(:login) }

    it { is_expected.to be true }
    it { expect { subject }.to have_published_event(CoreBy::Events::Users::Updated) }
  end
end
