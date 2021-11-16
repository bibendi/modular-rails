# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

# Load test-prof as earlier as possible
require "test_prof"

begin
  require File.expand_path("../../config/environment", __FILE__)
rescue => e
  # Fail fast if application couldn't be loaded
  $stdout.puts "Failed to load the app: #{e.message}\n#{e.backtrace.take(5).join("\n")}"
  exit(1)
end

# Prevent from running in non-test environment
abort("The Rails environment is running in #{Rails.env} mode!") unless Rails.env.test?

require "common/testing/rails_configuration"

# Disable PaperTrail to speed up tests
require "paper_trail/frameworks/rspec"

require "core_by/testing/shared_contexts"
require "core_by/testing/shared_examples"

RSpec.configure do |config|
  config.after(:suite) do
    # Cleanup attachments generated during tests
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
end
