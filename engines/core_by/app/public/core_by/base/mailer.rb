# frozen_string_literal: true

module CoreBy
  module Base
    class Mailer < ActionMailer::Base
      layout "mailer"

      # To avoid deprecation warning, will be the default in Rails 6.1
      # See https://github.com/rails/rails/pull/34591/ and https://github.com/rails/rails/pull/34692
      self.delivery_job = ::ActionMailer::MailDeliveryJob

      def self.mail_config
        @config ||= MailerConfig.new
      end

      delegate :mail_config, to: "self.class"

      default from: mail_config.from,
        reply_to: mail_config.reply_to

      helper_method :user
      helper_method :mail_config

      attr_reader :user

      before_action do
        next unless params

        @user = params[:user]
      end
    end
  end
end
