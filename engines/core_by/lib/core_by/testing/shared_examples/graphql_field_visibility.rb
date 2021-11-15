# frozen_string_literal: true

shared_examples_for "field is not accessible to unauthenticated users" do |field_name|
  context "when user is not provided" do
    let(:user) { nil }

    it "disallows access to the field" do
      expect(errors).not_to be_nil
      expect(errors).to include("Unauthenticated access to the field #{field_name}")
    end
  end
end

shared_examples_for "field is empty to unauthenticated users" do |field_name|
  context "when user is not provided" do
    let(:user) { nil }

    it "returns empty value for the field" do
      expect(errors).to be_nil
      expect(data[field_name]).to be_nil
    end
  end
end
