# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name = "common-rubocop"
  s.version = "1.0.0"
  s.summary = "Common RuboCop plugins and configuration"
  s.authors = ["Evil Martians"]

  s.files = Dir["{config,lib}/**/*", "Rakefile"]

  s.add_dependency "rubocop-performance", "~> 1.10"
  s.add_dependency "rubocop-rails", "~> 2.9"
  s.add_dependency "rubocop-rspec"
  s.add_dependency "standard", "= 1.3.0"

  s.add_development_dependency "bundler", ">= 2"
  s.add_development_dependency "rake", ">= 10.0"
  s.add_development_dependency "rspec", ">= 3.9"

  # Formatters
  # Progressbar-like formatter for RSpec
  s.add_dependency "fuubar", ">= 2.5"
  s.add_dependency "rspec-instafail", ">= 1.0"
  s.add_dependency "rspec_junit_formatter", ">= 0.4"
end
