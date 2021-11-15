# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

rails_version = File.read(File.join(__dir__, "../../.rails-version"))

Gem::Specification.new do |s|
  s.name = "common-factory"
  s.version = "1.0.0"
  s.summary = "Common factory bot utils"
  s.authors = ["Evil Martians"]

  s.files = Dir["{config,lib}/**/*", "Rakefile"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", rails_version

  s.add_dependency "factory_bot_rails", "~> 6.2"
  s.add_dependency "faker", "~> 2.7"

  s.add_development_dependency "bundler", ">= 2"
  s.add_development_dependency "rake", "~> 13.0"
end
