# frozen_string_literal: true

# require_relative "../lib/routes_utils/role_constraint"
require_relative "../lib/graphql_playground/rack"
require_relative "../lib/docsify/rack"

Rails.application.routes.draw do
  root to: redirect("/index.html")

  # Healthcheck
  get "/live" => "health#live"

  mount CoreBy::Engine => "/"
  # mount AuthBy::Engine => "/"

  # constraints(RoleConstraint[:admin]) do
  mount GraphQLPlayground::Rack.new => "/graphql"
  mount Docsify::Rack.new => "/docs"
  # end
end
