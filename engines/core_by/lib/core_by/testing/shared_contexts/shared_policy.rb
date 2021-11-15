# frozen_string_literal: true

shared_context "core_by:policy" do
  let(:user) { build_stubbed(:user) }

  let(:context) { {user: user} }
end

RSpec.configure do |config|
  config.include_context "core_by:policy", type: :policy
end
