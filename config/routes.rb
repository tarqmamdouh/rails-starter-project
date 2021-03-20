Rails.application.routes.draw do
  use_doorkeeper

   namespace :api do
    namespace :v1 do
      get '/users/me', to: 'users#me'
      resources :users
      resources :questions, except: :create
      post '/ask', to: 'questions#create'
      resources :answers
    end
  end
end
