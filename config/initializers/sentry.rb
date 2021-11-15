# frozen_string_literal: true

if defined?(Raven)
  module RavenContext
    extend ActiveSupport::Concern

    included do
      before_action :set_raven_context
    end

    private

    def set_raven_context
      if current_user
        Raven.user_context(
          id: current_user.id,
          email: current_user.email,
          phone: current_user.phone,
          name: current_user.name
        )
      end
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
  end

  # See https://docs.sentry.io/clients/ruby/
  Raven.configure do |config|
    config.dsn = Rails.application.config.sentry.dsn
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end

  # Action Controller
  ActiveSupport.on_load("core_by/base_controller") do
    include RavenContext
  end

  ActiveSupport.on_load("core_by/api/base_controller") do
    include RavenContext
  end

  # GraphQL
  ActiveSupport.on_load("core_by/application_schema") do
    singleton_class.prepend(Module.new do
      # Notify about `null: false` violations in return types
      # See https://graphql-ruby.org/errors/type_errors
      def type_error(exception, query_context)
        ::Raven.capture_exception(exception) if exception.is_a?(::GraphQL::InvalidNullError)
        super
      end
    end)
  end

  # Schked
  Schked.config.register_callback(:on_error) do |job, error|
    Raven.capture_exception(error)
  end
end
