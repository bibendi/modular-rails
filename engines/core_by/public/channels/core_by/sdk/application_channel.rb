# frozen_string_literal: true

module CoreBy
  module SDK
    class ApplicationChannel < ActionCable::Channel::Base
    end

    ActiveSupport.run_load_hooks("core_by/sdk/application_channel", ApplicationChannel)
  end
end
