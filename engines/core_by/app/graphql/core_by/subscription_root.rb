# frozen_string_literal: true

module CoreBy
  class SubscriptionRoot < Schema::Object
  end

  ActiveSupport.run_load_hooks("core_by/application_schema/subscription_root", SubscriptionRoot)
end
