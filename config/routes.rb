Rails.application.routes.draw do
  get "/home", to: "pages#home"
  get "/about", to: "pages#about"
  # Defines the root path route ("/")
  root "pages#home"
end
