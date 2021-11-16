# frozen_string_literal: true

module Testing
  module ControllerHelpers
    include Sorcery::TestHelpers::Rails::Controller

    alias_method :sign_in, :login_user
    alias_method :sign_out, :logout_user
  end
end

RSpec.configure do |config|
  config.include Testing::ControllerHelpers, type: :controller
end
