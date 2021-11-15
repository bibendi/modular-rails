# frozen_string_literal: true

require "rails_helper"

describe CoreBy::UserPolicy do
  let(:another_user) { build_stubbed :user }
  let(:record) { another_user }

  describe_rule :show? do
    succeed

    failed "when another user is admin" do
      before { another_user.role = "manager" }
    end

    failed "when discarded" do
      before { another_user.deleted_at = Time.current }
    end
  end
end
