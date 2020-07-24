Rails.application.routes.draw do
  root to: "tweets#index"
  resources :tweets, only: [:index] do
    collection do
      get 'search'
    end
  end
  resources :trends, only: [:index]
end
