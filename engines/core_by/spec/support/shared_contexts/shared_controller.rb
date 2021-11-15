# frozen_string_literal: true

ActiveSupport.on_load("core_by/base_controller") do
  attr_accessor :current_user
end

shared_context "core_by:controller" do
  routes { CoreBy::Engine.routes }

  def sign_in(user)
    controller.current_user = user
  end
end

RSpec.configure do |config|
  config.include_context "core_by:controller", type: :controller
end
