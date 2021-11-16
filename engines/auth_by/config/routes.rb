# frozen_string_literal: true

AuthBy::Engine.routes.draw do
  resources :reset, controller: :password_reset, param: :token, only: [:show, :update]
  resource :forgot, controller: :password_reset_request, only: [:show, :update]
end
