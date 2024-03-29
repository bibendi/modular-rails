# frozen_string_literal: true

ActiveSupport.on_load(:action_cable) do
  self.connection_class = -> { "CoreBy::SDK::CableConnection".constantize }
end
