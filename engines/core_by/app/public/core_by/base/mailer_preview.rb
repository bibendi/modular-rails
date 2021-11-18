# frozen_string_literal: true

# Use factory to generate preview data
require "common-factory"

module CoreBy
  module Base
    class MailerPreview < ActionMailer::Preview
      # TODO: make DB interactions read-only to avoid
      # _bad_ factories generated data from previews
      include FactoryBot::Syntax::Methods

      private

      def user
        @user ||= build_stubbed(:user)
      end

      def another_user
        @another_user ||= build_stubbed(:user)
      end
    end
  end
end
