Rails.application.routes.draw do
  # get 'plan_pages/preview'
  resources :plans
  resources :plan_pages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/plan_pages/selected_images', to: 'plan_pages#selected_images', as: 'selected_images'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "plans#index"
  resources :plan_pages do
    member do
      get 'show'
    end
  end
end
