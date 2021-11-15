# frozen_string_literal: true

require "common-factory"

require "rspec/rails"

require "isolator"
require "n_plus_one_control/rspec"
require "shoulda-matchers"
require "timecop"

require "common/testing/ext/action_dispatch_test_response"
require "common/testing/ext/n_plus_one_control_isolator"

require "test_prof/recipes/rspec/before_all"
require "test_prof/recipes/rspec/let_it_be"
require "test_prof/recipes/logging"
require "test_prof/recipes/rspec/any_fixture"
require "test_prof/ext/active_record_refind"
require "test_prof/any_fixture/dsl"
require "test_prof/recipes/rspec/factory_default"
require "test_prof/recipes/rspec/sample"

Dir[File.join(__dir__, "helpers/**/*.rb")].sort.each { |f| require f }
Dir[File.join(__dir__, "shared_contexts/**/*.rb")].sort.each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

NPlusOneControl.verbose = true

# Define whether we're withing engine or app
root = defined?(ENGINE_ROOT) ? Pathname.new(ENGINE_ROOT) : Rails.root

Dir[root.join("spec/support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = root.join("spec/fixtures")

  # Add `fixture_file_upload`
  config.include ActionDispatch::TestProcess
  # Add FactoryBot methods
  config.include FactoryBot::Syntax::Methods
  # Add `travel_to`
  config.include ActiveSupport::Testing::TimeHelpers

  config.use_transactional_fixtures = true

  # See https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  unless ENV["FULLTRACE"]
    config.filter_rails_from_backtrace!

    # Request/Rack middlewares
    config.filter_gems_from_backtrace "railties", "rack", "rack-test"
  end

  config.after(:each) do
    # Make sure every example starts with the current time
    Timecop.return
    travel_back

    # Clear ActiveJob jobs
    if defined?(ActiveJob) && ActiveJob::QueueAdapters::TestAdapter === ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
      ActiveJob::Base.queue_adapter.performed_jobs.clear
    end

    # Clear test redis database
    Redis.current.flushdb
  end
end
