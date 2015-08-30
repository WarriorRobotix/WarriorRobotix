Rails.application.routes.draw do
  root 'pages#home'

  resources :members do
    resources :attendances
    post '/reject' => 'members#reject'
    post '/approve'  => 'members#approve'
  end

  resources :posts, type: "Post"

  resources :events, only: [:new, :create, :edit, :update] do
    post '/reply' => 'events#reply', :constraints => {:format => :js}
  end

  resources :polls, only: [:new, :create, :edit, :update] do
    post '/vote' => 'polls#vote', :constraints => {:format => :js}
  end

  get '/events', to: redirect('/posts')
  get '/polls', to: redirect('/posts')

  resources :events, only: [:index, :destroy, :show], controller: :posts, type: "Event"
  resources :polls, only: [:index, :destroy, :show], controller: :posts, type: "Poll"

  resources :sponsors, except: [:show]

  resources :photos, except: [:show]

  resources :competitions, except: [:show]

  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  delete 'signout' => 'sessions#destroy'

  get 'forgot' => 'members#forgot'
  post 'forgot' => 'members#send_reset_token'

  get 'email' => 'members#edit_email'
  post 'email' => 'members#update_email'

  get 'password' => 'members#edit_password'
  post 'password' => 'members#update_password'

  get 'reset/:record_hex/:reset_token' => 'members#reset_password_edit', as: :reset_password, type: :reset
  post 'reset/:record_hex/:reset_token' => 'members#reset_password_update', type: :reset

  get '/set-password/:record_hex/:reset_token' => 'members#reset_password_edit', type: :set
  post '/set-password/:record_hex/:reset_token' => 'members#reset_password_update', type: :set

  get '/attend' => 'pages#attend'
  get '/search' => 'members#search'

  get '/register' => 'registrations#form'
  post '/register' => 'registrations#submit'

  get '/r' => 'registrations#form'
  post '/r' => 'registrations#submit'

  post 'registration/toggle' => 'registrations#toggle'

  resources :registration_fields, except: [:show] do
    collection do
      post '/fix' => 'registration_fields#fix'
    end
    post '/up' => 'registration_fields#up'
    post '/down' => 'registration_fields#down'
  end

end
