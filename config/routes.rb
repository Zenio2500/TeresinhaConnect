Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy", as: :logout
  delete "logout", to: "sessions#destroy"

  root "sessions#new"

  get "dashboard", to: "home#index", as: :dashboard

  resources :users
  resources :pastorals
  resources :grades do
    member do
      post :add_reader
      delete :remove_reader
    end
  end
  resources :readers
end
