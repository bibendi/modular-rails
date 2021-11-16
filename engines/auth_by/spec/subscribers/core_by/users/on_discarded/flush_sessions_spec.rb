# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Users::OnDiscarded::FlushSessions do
  let_it_be(:user) { create :user }

  let(:event) { CoreBy::Users::Discarded.new(user: user) }

  subject { described_class.call(event) }

  it "is subscribed to registered" do
    expect { Downstream.publish event }
      .to have_enqueued_async_subscriber_for(described_class).with(event)
  end

  it "deletes all user's sessions" do
    tokens = user.becomes(AuthBy::User).generate_jwt_tokens

    subject

    expect(JWTSessions::Session.new.session_exists?(tokens[:access], "access")).to be false
    expect(JWTSessions::Session.new.session_exists?(tokens[:refresh], "refresh")).to be false
  end
end
