# frozen_string_literal: true

module CoreBy
  class SubscriptionRoot < SDK::Schema::Object
  end

  ActiveSupport.run_load_hooks("core_by/subscription_root", SubscriptionRoot)
end
