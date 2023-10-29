# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'weather#index'
  resources :weather, only: [:index]
end
