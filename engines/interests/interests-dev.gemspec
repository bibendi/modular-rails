# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "interests-dev"
  s.version = "1.0.0"
  s.authors = ["Evil Martians"]
  s.summary = "User interests engine dev"

  s.add_dependency "bootsnap", "~> 1.4"
  s.add_dependency "brakeman", "~> 5.0"
  s.add_dependency "bundler", ">= 2.0"
  s.add_dependency "rake", "~> 13.0"

  # Internal
  s.add_dependency "common-rubocop"
  s.add_dependency "common-testing"
end
