Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  devise_for :users


  resources :companies do
    # resources :jobs, only: [:new, :create, :index]
    resources :jobs
  end

  resources :jobs do
    # resources :job_applications, only: [:new, :create, :index, :show]
    resources :job_applications, only: [ :new, :create ]
  end
0
  # resources :jobs, only: [:show,:edit,:update]
  namespace :public do
    resources :companies, only: [ :index ]
  end
  resource :profile, only: [ :show, :edit, :update ]



  # Add the main dashboards controller
  root "dashboards#index"

  # root 'dashboards#index'  # Set root path
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
