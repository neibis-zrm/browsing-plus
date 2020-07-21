Rails.application.routes.draw do
  root to: "browses#index"
  resources :browses, only: [:index]
end
