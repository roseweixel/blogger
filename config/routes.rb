Rails.application.routes.draw do
  root 'welcome#index'

  resources :blogs

  resources :users

  resources :memberships

  resources :cohorts do 
    resources :schedules
  end

  post 'generate_blog_rotation' => 'schedules#generate_blog_rotation'

  post 'get_new_posts' => 'cohorts#get_new_posts'

  post 'set_blog_rotation' => 'schedules#set_blog_rotation'

  match 'login', to: redirect('/auth/github'), via: [:get, :post]

  get '/auth/:provider/callback', to: 'sessions#create'

  get 'logout' => 'sessions#destroy'
end
