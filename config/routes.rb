Rails.application.routes.draw do
  resources :projects, only: [:index] do
    resources :todos, only: [:update]
  end
  resources :todos, only: [:create]
end
