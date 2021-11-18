# frozen_string_literal: true

module CoreBy
  module Entities
    class User
      delegate :id, :external_id, :login, :name, :first_name, :last_name, :membership_state,
        :email, :phone, :role, :discarded?, :disabled?, to: :user

      class << self
        def from(user)
          new(user) if user
        end
      end

      def initialize(user)
        @user = user
      end

      # We need this method because graphql types are relies on active record models.
      # Basically, we can use send an entity to graphql type, but we should not do that because of:
      # - we have to be insync with graphql type (have the same attributes)
      # - relay connections
      # We need implement Rubocop cop so that a developer cannot use this method anywhere.
      # Perhaps, we can use some extenstion for that https://github.com/rmosolgo/graphql-ruby/blob/07fa8715abc5abbd91ab6d522112791952450454/lib/graphql/schema/field.rb#L706
      def to_record
        user
      end

      private

      attr_reader :user
    end
  end
end
