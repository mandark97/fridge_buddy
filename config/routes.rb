Rails.application.routes.draw do
  root 'homepage#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :recipes, only: [:index, :show] do
        get :fridge, on: :collection
      end
    end
  end

  get "*path", to: 'homepage#index', format: false
end
