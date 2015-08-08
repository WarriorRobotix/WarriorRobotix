Rails.application.routes.draw do

  root 'posts#index', type: 'Post'

  resources :members do
    resources :attendances
  end

  resources :posts, type: 'Post'
  resources :events, controller: :posts, type: 'Event'

  resources :events do
    get '/yes' => 'events#confirm'
    get '/maybe' => 'events#maybe'
    get '/no' => 'events#decline'
  end

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
