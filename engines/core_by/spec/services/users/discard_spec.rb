# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Users::Discard do
  let_it_be(:user, reload: true) { create(:user) }

  subject { described_class.call(user) }

  specify do
    expect { subject }
      .to change(user, :discarded?).from(false).to(true)
      .and have_published_event(CoreBy::SDK::Users::Discarded)
      .with(user: user.to_entity)
  end
end
