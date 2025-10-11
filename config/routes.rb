Rails.application.routes.draw do
  devise_for :users, path: "/"

  namespace :api do
    namespace :v1 do
      post :auth, to: "auth#create"
      resources :entries, only: %i[index]
    end
  end

  resources :entries

  root "entries#index"
end
