# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :vendors, only: %i[show new create update destroy]
      resources :market_vendors, only: %i[create]
      delete 'market_vendors', to: 'market_vendors#destroy'
      get 'markets/search', to: 'markets_search#index'
      resources :markets, only: %i[index show] do
        resources :vendors, only: %i[index]
        get '/nearest_atms', to: 'atms#index'
      end
    end
  end
end
