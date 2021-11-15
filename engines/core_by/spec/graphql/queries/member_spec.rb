# frozen_string_literal: true

require "rails_helper"

describe "{ member { ... } }" do
  let_it_be(:another_user, reload: true) { create(:member, login: "james", name: "James Bond") }

  let(:variables) { {id: another_user.external_id} }

  let(:query) do
    <<~GRAPHQL
      query getMember($id: ID, $login: String){
        member(id: $id, login: $login) {
          id
          login
          name
          firstName
          lastName
          role
          phone
          email
          myself
        }
      }
    GRAPHQL
  end

  it "returns user" do
    expect(data.fetch("firstName")).to eq "James"
    expect(data.fetch("lastName")).to eq "Bond"
    expect(data.fetch("myself")).to be false
    expect(data.fetch("phone")).to be nil
    expect(data.fetch("login")).to eq "james"
    expect(data.fetch("email")).to be nil
  end

  context "when find by login" do
    let(:variables) { {login: another_user.login} }

    it "returns user" do
      expect(data.fetch("firstName")).to eq "James"
    end
  end

  context "when user is an admin" do
    before { another_user.update!(role: "admin") }

    it "does not return user" do
      expect(errors).not_to be_nil
      expect(errors).to include("Not found")
    end
  end

  context "when user is deleted" do
    before { another_user.discard! }

    it "returns user" do
      expect(errors).not_to be_nil
      expect(errors).to include("Not found")
    end
  end
end
