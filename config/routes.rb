Rails.application.routes.draw do

  #root 'posts#index', type: 'Post'
  root 'pages#home'

  resources :members do
    resources :attendances
  end

  resources :posts, type: 'Post'

  resources :events, only: [:new, :create, :edit, :update] do
    post '/reply' => 'events#reply', :constraints => {:format => :js}
  end

  resources :polls, only: [:new, :create, :edit, :update] do
    post '/vote' => 'polls#vote', :constraints => {:format => :js}
  end

  resources :events, except: [:new, :create, :edit, :update], controller: :posts, type: 'Event'
  resources :polls, except: [:new, :create, :edit, :update], controller: :posts, type: 'Poll'


  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  delete 'signout' => 'sessions#destroy'

  get 'test' => 'pages#test'

  get 'email' => 'members#email_edit'
  post 'email' => 'members#email_update'

  get 'password' => 'members#password_edit'
  post 'password' => 'members#password_update'

  get 'reset/:record_hex/:reset_token' => 'members#reset_password_edit'
  post 'reset/:record_hex/:reset_token' => 'members#reset_password_update'
end
