# frozen_string_literal: true

require_relative "./production"

Rails.application.configure do
  config.action_mailer.show_previews = true
  config.action_mailer.preview_path = Rails.root.join("spec", "mailers", "previews").to_s
end
