# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

rails_version = File.read(File.join(__dir__, "../../.rails-version"))

Gem::Specification.new do |s|
  s.name = "core_by"
  s.version = "1.0.0"
  s.summary = "Base classes and configuration engine"
  s.authors = ["Evil Martians"]

  s.files = Dir["{app,config,db,lib}/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "action_policy", "~> 0.3"
  s.add_dependency "activejob-status", "~> 0.1"
  s.add_dependency "activejob-uniqueness", "~> 0.2"
  s.add_dependency "activerecord-postgres_enum", "~> 1.0"
  s.add_dependency "after_commit_everywhere", "~> 1.0"
  s.add_dependency "anycable", "~> 1.1"
  s.add_dependency "anycable-rails", "~> 1.1"
  s.add_dependency "database_validations", "~> 1.0"
  s.add_dependency "discard", "~> 1.2"
  s.add_dependency "downstream", "~> 1.3"
  s.add_dependency "dry-initializer", "~> 3.0"
  s.add_dependency "graphql-anycable", "~> 1.0"
  s.add_dependency "hiredis", "~> 0.6"
  s.add_dependency "imgproxy", "~> 2.0"
  s.add_dependency "name_of_person", "~> 1.1"
  s.add_dependency "nanoid", "~> 2.0"
  s.add_dependency "paper_trail", "~> 12.0"
  s.add_dependency "pg", "~> 1.0"
  s.add_dependency "phonelib", "~> 0.6"
  s.add_dependency "rails", rails_version
  s.add_dependency "rails-i18n", "~> 6.0"
  s.add_dependency "redis-mutex", "~> 4.0"
  s.add_dependency "schked", "~> 0.3"
end
