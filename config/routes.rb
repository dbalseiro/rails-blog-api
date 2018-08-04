Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :articles do
    resources :comments

    collection do
      get 'search'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :articles
    end
  end
end
