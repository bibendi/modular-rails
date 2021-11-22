# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

rails_version = File.read(File.join(__dir__, "../../.rails-version"))

Gem::Specification.new do |s|
  s.name = "interests"
  s.version = "1.0.0"
  s.authors = ["Evil Martians"]
  s.summary = "User interests engine"

  s.files = Dir["{app,config,db,lib}/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "pg", "~> 1.0"
  s.add_dependency "rails", rails_version

  # Internal
  s.add_dependency "core_by"
end
