# frozen_string_literal: true

shared_context "common:request" do
  subject { request; response } # rubocop:disable Style/Semicolon
end

RSpec.configure do |config|
  config.include_context "common:request", type: :request
  config.include Common::Testing::JSONResponse, type: :request
  config.include Common::Testing::JSONResponse, type: :controller
end
