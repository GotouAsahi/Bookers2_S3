Rails.application.routes.draw do
  devise_for :users

  root to: 'homes#top'
  get 'home/about' => 'homes#about'

  resources :books, only: %i[index show edit create destroy update] do
    resources :book_comments, only: %i[create destroy]
    resource :favorites, only: %i[create destroy]
  end
  resources :users, only: %i[index show edit update] do
    resource :relationships, only: %i[create destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'

    post 'search' => 'users#search'

  end
  resources :chats, only: %i[show create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
