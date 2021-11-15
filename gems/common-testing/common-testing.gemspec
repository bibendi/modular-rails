# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

rails_version = File.read(File.join(__dir__, "../../.rails-version"))

Gem::Specification.new do |s|
  s.name = "common-testing"
  s.version = "1.0.0"
  s.summary = "Common configuration for RSpec and Dummy application"
  s.authors = ["Evil Martians"]

  s.files = Dir["{config,lib}/**/*", "Rakefile"]

  # Core
  s.add_dependency "rails", rails_version
  s.add_dependency "rspec-rails", "~> 5.0"

  # Tools
  s.add_dependency "combustion", "~> 1.3"
  s.add_dependency "debug", "~> 1.1"
  s.add_dependency "isolator", "~> 0.7"
  s.add_dependency "n_plus_one_control", "~> 0.6"
  s.add_dependency "shoulda-matchers"
  s.add_dependency "test-prof", "~> 1.0"
  s.add_dependency "timecop", "~> 0.9"

  # Formatters
  # Progressbar-like formatter for RSpec
  s.add_dependency "fuubar", "~> 2.5"
  s.add_dependency "rspec-instafail", "~> 1.0"
  s.add_dependency "rspec_junit_formatter", "~> 0.4"

  # Internal
  s.add_dependency "common-factory"

  s.add_development_dependency "bundler", ">= 2"
  s.add_development_dependency "rake", "~> 13.0"
end
