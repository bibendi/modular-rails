# frozen_string_literal: true

require_relative "../lib/routes_utils/role_constraint"
require_relative "../lib/graphql_playground/rack"
require_relative "../lib/docsify/rack"

Rails.application.routes.draw do
  root to: redirect("/index.html")

  mount CoreBy::Engine => "/"
  mount AuthBy::Engine => "/"

  constraints(RoleConstraint[:admin]) do
    mount GraphQLPlayground::Rack.new => "/graphql"
    mount GraphdocRuby::Application => "/docs/graphql"
    mount Docsify::Rack.new => "/docs"
  end

  # Kubernetes healthcheck
  get "/live" => "health#live"
end
