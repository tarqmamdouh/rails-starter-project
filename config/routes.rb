Rails.application.routes.draw do
  use_doorkeeper

   namespace :api do
    namespace :v1 do
      
      get '/users/me', to: 'users#me'
      resources :users
      
      get '/questions/tagged_with'
      resources :questions, except: [:create] do
        resources :answers
      end
      post '/ask', to: 'questions#create'
      resources :tags, only: :index
    end
  end
end
