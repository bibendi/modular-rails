# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "core_by-dev"
  s.version = "1.0.0"
  s.summary = "Base classes and configuration engine DEV"
  s.authors = ["Evil Martians"]

  s.add_dependency "bootsnap", "~> 1.4"
  s.add_dependency "brakeman", "~> 5.0"
  s.add_dependency "bundler", ">= 2.0"
  s.add_dependency "rake", "~> 13.0"

  # Internal
  s.add_dependency "common-factory"
  s.add_dependency "common-rubocop"
  s.add_dependency "common-testing"
end
