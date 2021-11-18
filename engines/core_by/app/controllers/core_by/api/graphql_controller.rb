# frozen_string_literal: true

module CoreBy
  module Api
    class GraphQLController < Base::ApplicationController
      def execute
        variables = ensure_hash(params[:variables]).compact
        query = params[:query]
        operation_name = params[:operationName].presence

        result = CoreBy::ApplicationSchema.execute(
          query,
          variables: variables,
          context: build_context,
          operation_name: operation_name
        )
        render json: result
      end

      private

      def build_context
        {
          extensions: ensure_hash(params[:extensions]),
          current_user: current_user
        }
      end

      # Handle form data, JSON body, or a blank value
      def ensure_hash(ambiguous_param)
        case ambiguous_param
        when String
          if ambiguous_param.present?
            ensure_hash(JSON.parse(ambiguous_param))
          else
            {}
          end
        when Hash
          ambiguous_param
        when ActionController::Parameters
          ambiguous_param.to_unsafe_hash
        when nil
          {}
        else
          raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
        end
      end

      def respond_with_error(msg, **ext)
        # In this method we are trying to pretend as GraphQL response.
        # So in GraphQL world there is always 200 OK status.
        ext.delete(:status)

        render(
          json: {
            errors: [
              message: msg,
              extensions: ext
            ]
          }
        )
      end
    end
  end
end
