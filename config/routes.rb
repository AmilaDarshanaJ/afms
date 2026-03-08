Rails.application.routes.draw do
  resources :financial_records
  # --- Static Pages ---
  get "pages/about"
  get 'about', to: 'pages#about'
  get "home/index"

  # --- Authentication ---
  # 'resource :session' is the standard Rails 7.1+ auth route
  resource :session
  resources :passwords, param: :token

  # Custom logout route to match your button
  delete "/logout", to: "sessions#destroy", as: :logout

  # Only keep one sessions resource if possible, but I left yours here to avoid breaking old code
  resources :sessions, only: [:new, :create, :destroy]

  # --- Admin Management (NEW) ---
  # This enables users_path, new_user_path, etc.
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  resource :profile, only: [:show, :edit, :update]

  # --- Farm Resources ---
  resources :lands

  resources :crop_types

  resources :activities do
    collection do
      get :report # Generates: report_activities_path
    end
  end

  resources :harvests do
    collection do
      get :report     # Generates: report_harvests_path
      get :report_pdf
    end
  end

  # --- System Health ---
  get "up" => "rails/health#show", as: :rails_health_check

  # --- Root Path ---
  root "home#index"
end