# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    PaperTrail.enabled = false
  end
end
