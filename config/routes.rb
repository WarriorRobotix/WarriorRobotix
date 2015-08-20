Rails.application.routes.draw do
  root 'pages#home'

  resources :members do
    resources :attendances
    post '/reject' => 'members#reject'
    post '/approve'  => 'members#approve'
  end

  resources :posts, type: "Post"

  resources :events, only: [:new, :create, :edit, :update, :show] do
    post '/reply' => 'events#reply', :constraints => {:format => :js}
  end

  resources :polls, only: [:new, :create, :edit, :update, :show] do
    post '/vote' => 'polls#vote', :constraints => {:format => :js}
  end

  get '/events', to: redirect('/posts')
  get '/polls', to: redirect('/posts')

  resources :events, only: [:index, :destroy], controller: :posts, type: "Event"
  resources :polls, only: [:index, :destroy], controller: :posts, type: "Poll"

  resources :sponsors, except: [:show]

  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  delete 'signout' => 'sessions#destroy'


  get 'email' => 'members#email_edit'
  post 'email' => 'members#email_update'

  get 'password' => 'members#password_edit'
  post 'password' => 'members#password_update'

  get 'reset/:record_hex/:reset_token' => 'members#reset_password_edit'
  post 'reset/:record_hex/:reset_token' => 'members#reset_password_update'

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
