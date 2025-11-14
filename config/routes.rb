Rails.application.routes.draw do
  resources :activities
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resources :lands

  resources :harvests do
    collection do
      get :report
    end
  end

  delete "/logout", to: "sessions#destroy", as: :logout

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
