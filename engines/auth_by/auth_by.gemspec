# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

rails_version = File.read(File.join(__dir__, "../../.rails-version"))

Gem::Specification.new do |s|
  s.name = "auth_by"
  s.version = "1.0.0"
  s.summary = "Authenticate engine"
  s.authors = ["Evil Martians"]

  s.files = Dir["{app,config,db,lib}/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "jwt_sessions", "~> 2.7"
  s.add_dependency "pg", "~> 1.0"
  s.add_dependency "rails", rails_version
  s.add_dependency "slim-rails"
  s.add_dependency "sorcery", "~> 0.14"

  # Internal
  s.add_dependency "core_by"
end
