Rails.application.routes.draw do
  devise_for :admins

  authenticated :admin_user do
    root to: "admin#index", as: :admin_root
  end

  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  resources :categories, only: [ :show ]
  resources :products, only: [ :show ]

  get "admin" => "admin#index"
  get "admins/:id" => "admin#show", as: :admin_show
  get "cart" => "carts#show"
end
