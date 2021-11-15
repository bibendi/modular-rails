# frozen_string_literal: true

module CoreBy
  module Schema
    class Field < ::GraphQL::Schema::Field
      def initialize(*args, authenticate: false, user_checks: nil, **kwargs, &block)
        @authenticate = authenticate
        @user_checks = user_checks

        super(*args, **kwargs, &block)
      end

      def authenticate?
        !!@authenticate
      end

      def user_checks?
        user_checks.is_a?(Hash) && !user_checks.empty?
      end

      def authorized?(object, args, context)
        if user_checks?
          authorize_user_checks(context[:current_user])
        elsif authenticate?
          authenticate!(context[:current_user])
        end

        super
      end

      private

      attr_reader :user_checks

      def authenticate!(user)
        return unless user.nil?

        raise ::GraphQL::ExecutionError.new(
          "Unauthenticated access to the field #{graphql_name}",
          extensions: {code: :unauthenticated, reason: :user_not_found}
        )
      end

      def authorize_user_checks(user)
        authenticate!(user)

        user_checks.each do |check, expectation|
          next if user.public_send("#{check}?") == expectation

          raise ::GraphQL::ExecutionError.new(
            "Unauthorized access to the field #{graphql_name}",
            extensions: {code: :unauthorized, reason: "Expected user #{"not " unless expectation}to be #{check}"}
          )
        end

        true
      end
    end
  end
end
