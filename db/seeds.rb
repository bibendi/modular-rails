# frozen_string_literal: true

require "core_by/seeds/dsl"

using CoreBy::Seeds::DSL

ActiveRecord::Base.transaction do
  announce "Auth By" do
    AuthBy::Engine.load_seed
  end

  announce "Tasks By" do
    TasksBy::Engine.load_seed
  end
end
