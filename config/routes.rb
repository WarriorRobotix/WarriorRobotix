Rails.application.routes.draw do
  root 'pages#home'

  resources :members do
    collection do
      post '/reject' => 'members#reject'
    end
    post '/approve'  => 'members#approve'
    resources :attendances
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

  resources :videos, except: [:show]

  resources :teams

  post 'add_team_member' => 'teams#add_team_member'
  post 'remove_team_member' => 'teams#remove_team_member'

  resources :competitions

  scope :attendances do
    get 'center' => 'attendances#center', as: :attendances_center
    post 'check_in' => 'attendances#check_in'
    post 'set_check_in' => 'attendances#set_check_in'
    post 'check_out/:id' => 'attendances#check_out', as: :check_out
  end

  post '/checkout_all' => 'attendances#checkout_all'
  post '/checkin_group' => 'attendances#checkin_group'
  post '/checkout_group' => 'attendances#checkout_group'

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
  get '/event' => 'pages#event'
  get '/vex' => 'pages#vex'
  get '/skills' => 'pages#skills'
  get '/frc-ceta' => 'pages#other_competitions'
  get '/team-editor' => 'pages#team_editor'
  get '/about' => 'pages#about_us'
  get '/myattendance' => 'pages#my_attendance'
  get '/contact' => 'pages#contact', :constraints => {:format => :html}
  post '/contact' => 'pages#contact_message', :constraints => {:format => :html}
  get '/search' => 'members#search'
  get '/eventsearch' => 'members#eventsearch'

  get '/register' => 'registrations#form'
  post '/register' => 'registrations#submit'
  get '/register/contract' => 'pages#member_contract'

  post 'registration/toggle' => 'registrations#toggle'

  resources :registration_fields, except: [:show] do
    collection do
      post '/fix' => 'registration_fields#fix'
    end
    post '/up' => 'registration_fields#up'
    post '/down' => 'registration_fields#down'
  end

end
