# frozen_string_literal: true

CoreBy::Engine.routes.draw do
  post "/api/graphql", to: "api/graphql#execute"
end
