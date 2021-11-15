# frozen_string_literal: true

module CoreBy
  module Api
    class BaseController < ActionController::API
      include ::ActiveStorage::SetCurrent
      include AuthBehaviour

      rescue_from "ActiveRecord::RecordNotFound" do |exception|
        respond_with_error("Not found", status: 404, code: :not_found, reason: :record_not_found)
      end

      rescue_from "ActiveModel::ValidationError", "ActiveRecord::RecordInvalid" do |exception|
        if exception.respond_to?(:record)
          respond_with_error(
            "Record invalid",
            status: 422,
            code: :invalid,
            reason: :record_invalid,
            full_messages: exception.record.errors.full_messages
          )
        else
          respond_with_error(exception.message, status: 422, code: :invalid, reason: :record_invalid)
        end
      end

      rescue_from(GraphQL::PersistedQueries::WrongHash) do |exception|
        respond_with_error("Persisted query wrong hash", status: 422, code: :invalid, reason: :wrong_hash)
      end

      private

      def not_authenticated
        respond_with_error("Unauthenticated access", status: 401, code: :unauthenticated)
      end

      def not_authorized
        respond_with_error("Unauthorized access", status: 403, code: :unauthorized)
      end

      def respond_with_error(msg, status:, **ext)
        render(
          json: {
            errors: [
              message: msg,
              extensions: ext
            ]
          },
          status: status
        )
      end
    end

    ActiveSupport.run_load_hooks("core_by/api/base_controller", BaseController)

    unless BaseController.instance_methods.include?(:current_user)
      class BaseController
        attr_accessor :current_user
      end
    end
  end
end
