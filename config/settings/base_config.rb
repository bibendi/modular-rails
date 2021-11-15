# frozen_string_literal: true

# Base abstract class for config files.
# It provides `instance` method which returns the default
# instance for this config
class BaseConfig < Anyway::Config
  class << self
    delegate_missing_to :instance

    def instance
      @instance ||= new
    end
  end
end
