# frozen_string_literal: true

require "rails_helper"

describe "/rails/mailers" do
  subject { response }

  ActionMailer::Preview.all.each do |preview|
    next if preview.emails.empty?

    describe "/#{preview.preview_name}" do
      preview.emails.each do |email|
        specify "/#{email}" do
          get "/rails/mailers/#{preview.preview_name}/#{email}"
          is_expected.to be_successful
        end
      end
    end
  end
end
