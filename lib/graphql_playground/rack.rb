# frozen_string_literal: true

require "erb"
require "json"

module GraphQLPlayground
  # Rack app to serve GraphiQL
  # Based on https://github.com/yuya-takeyama/rack-graphiql
  class Rack
    include ERB::Util

    attr_reader :endpoint, :subscription_endpoint

    def initialize(endpoint: "/api/graphql", subscription_endpoint: Rails.application.config.action_cable.url)
      @endpoint = endpoint
      @subscription_endpoint = subscription_endpoint
      @template = ERB.new(File.read(File.join(__dir__, "template.html.erb")))
    end

    def call(env)
      [200, {"Content-Type" => "text/html"}, [@template.result(binding)]]
    end
  end
end
