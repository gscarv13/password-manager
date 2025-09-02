Rails.application.routes.draw do
  devise_for :users, path: "/"

  get "/home", to: "pages#home"
  get "/about", to: "pages#about"

  resources :entries

  # Defines the root path route ("/")
  root "entries#index"
end
