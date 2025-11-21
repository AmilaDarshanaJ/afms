Rails.application.routes.draw do
  get "pages/about"

  get 'about', to: 'pages#about'

  resources :sessions, only: [:new, :create, :destroy]

  resources :activities
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resources :lands

  resources :harvests do
    collection do
      get :report
      get :report_pdf
    end
  end

  delete "/logout", to: "sessions#destroy", as: :logout

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
