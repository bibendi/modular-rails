# frozen_string_literal: true

require "rails_helper"

describe CoreBy::ActiveStorage do
  let(:config) { Rails.application.config }
  let(:url_helpers) { Rails.application.routes.url_helpers }

  before { described_class.instance_eval { @url_options = nil } }

  describe ".attachment_url" do
    let_it_be(:user) { create :user, :with_avatar }

    let(:attachment) { user.avatar }
    let(:variant) { nil }

    subject { described_class.attachment_url(attachment, variant: variant) }

    context "when without variant" do
      it { is_expected.to start_with("http://localhost/rails/active_storage/disk") }
    end

    context "when variant is provided" do
      let(:variant) { :basic }

      specify do
        is_expected
          .to start_with("http://imgproxy/unsafe/rs:fit:400:400/plain/http://localhost/rails/active_storage/disk")
      end

      context "and it does not exist" do
        let(:variant) { :wrong }

        it { expect { subject }.to raise_error(KeyError) }
      end
    end
  end
end
