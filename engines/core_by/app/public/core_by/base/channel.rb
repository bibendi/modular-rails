# frozen_string_literal: true

module CoreBy
  module Base
    class Channel < ActionCable::Channel::Base
    end

    ActiveSupport.run_load_hooks("core_by/base/channel", Channel)
  end
end
