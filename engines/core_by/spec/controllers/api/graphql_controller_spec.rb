# frozen_string_literal: true

require "rails_helper"

describe CoreBy::Api::GraphQLController do
  subject { post :execute, params: {query: "query { time }"} }

  it "responds ok" do
    is_expected.to have_http_status(200)
    expect(subject.body).to include("time")
  end
end
