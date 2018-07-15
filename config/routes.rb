Rails.application.routes.draw do
  resources :articles do
    resources :comments

    collection do
      get 'search'
    end
  end
end
