Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Rotas de Sessão (Login/Logout)
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy", as: :logout
  delete "logout", to: "sessions#destroy"

  # Página Inicial (Login)
  root "sessions#new"

  # Painel de Controle (Dashboard)
  get "dashboard", to: "home#index", as: :dashboard

  # Recursos com CRUD completo
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
