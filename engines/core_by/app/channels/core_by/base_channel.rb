# frozen_string_literal: true

module CoreBy
  class BaseChannel < ActionCable::Channel::Base
    ActiveSupport.run_load_hooks("core_by/cable_channel", self)
  end
end
