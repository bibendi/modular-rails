# frozen_string_literal: true

using(Module.new do
  refine Hash do
    def camelize_keys
      deep_transform_keys { |key| GraphQL::Schema::Member::BuildType.camelize(key.to_s) }
    end
  end
end)

shared_context "core_by:graphql" do
  include_context "core_by:user"

  let(:schema) { CoreBy::ApplicationSchema }
  let(:context) do
    {
      current_user: user,
      current_locale: "en"
    }
  end
  let(:variables) { {} }
  let(:field) { result.fetch("data").keys.first }

  let(:data) do
    raise "API Query failed:\n\tquery: #{query}\n\terrors: #{result["errors"]}" if result.key?("errors")
    result.fetch("data").dig(*field.split("->"))
  end

  let(:errors) { result["errors"]&.map { |err| err["message"] } }
  let(:reasons) { result["errors"]&.map { |err| err["extensions"]["reason"] } }

  # for connection responses
  let(:edges) { data.fetch("edges").map { |node| node.fetch("node") } }
  let(:page_info) { data.fetch("pageInfo") }

  def execute_gql_query
    schema.execute(
      query,
      context: context,
      variables: variables.camelize_keys
    )
  end

  subject(:result) do
    execute_gql_query
  end
end

RSpec.configure do |config|
  config.include_context "core_by:graphql", type: :graphql

  config.before(:each) do
    allow(CoreBy::ApplicationSchema).to receive(:subscriptions).and_return(spy("Graphql Subscriptions Adapter"))
  end
end
