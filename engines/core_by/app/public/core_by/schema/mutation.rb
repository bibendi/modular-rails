# frozen_string_literal: true

module CoreBy
  module Schema
    class Mutation < ::GraphQL::Schema::Mutation
      include ::ActionPolicy::GraphQL::Behaviour

      # Syntax sugar for raising an execution
      # error with the specified code
      def fail_with!(code, msg, ext = {})
        raise ::GraphQL::ExecutionError.new(
          msg,
          extensions: {code: code}.merge!(ext)
        )
      end
    end
  end
end
