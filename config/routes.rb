Rails.application.routes.draw do
  resources :activities
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resources :lands
  resources :harvests


  # 👇 Add this line for logout
  delete "/logout", to: "sessions#destroy", as: :logout

  # Define your application routes

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
