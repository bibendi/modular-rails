# frozen_string_literal: true

require "core_by/seeds/dsl"

using CoreBy::Seeds::DSL

ActiveRecord::Base.transaction do
  announce "Core By" do
    CoreBy::Engine.load_seed
  end

  announce "Auth By" do
    AuthBy::Engine.load_seed
  end
end
