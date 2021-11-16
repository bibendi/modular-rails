# frozen_string_literal: true

require "rails_helper"

describe SentryConfig, type: :config do
  subject { described_class.new }

  specify do
    with_env(
      "SENTRY_DSN" => "https://12345:4321@sentry.io/5678"
    ) do
      is_expected.to have_attributes(
        dsn: "https://12345:4321@sentry.io/5678"
      )
    end
  end
end
