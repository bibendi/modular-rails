# frozen_string_literal: true

Rails.application.routes.draw do
  mount CoreBy::Engine => "/"
  mount AuthBy::Engine => "/"

  root to: "welcome#index"
end
