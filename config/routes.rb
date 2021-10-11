Rails.application.routes.draw do
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]
  get 'search/search'
  devise_for :users
  root to: 'homes#top'
  get '/home/about' => 'homes#about'
  get '/search' => 'search#search'

  resources :books, only: [:index, :create, :show, :edit, :update, :destroy] do

    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end


  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

end
