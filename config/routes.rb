Rails.application.routes.draw do

  root 'posts#index', type: 'Post'

  resources :members do
    resources :attendances
  end

  resources :posts, type: 'Post'
  resources :events, controller: :posts, type: 'Event'
  resources :polls, controller: :posts, type: 'Poll'

  resources :events, only: [] do
    post '/reply' => 'events#reply'
  end

  resources :polls, only: [] do
    post '/reply' => 'polls#reply'
  end

  post '/options/append' => 'polls#append_option', as: :append_option

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
