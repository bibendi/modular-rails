# frozen_string_literal: true

Rails.application.routes.draw do
  mount CoreBy::Engine => "/"
end
