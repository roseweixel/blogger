Rails.application.routes.draw do
  root 'welcome#index'

  resources :holidays, only: [:create]

  resources :blogs

  resources :posts

  resources :users

  resources :memberships

  resources :cohorts do 
    resources :schedules
  end

  post 'generate_blog_rotation' => 'schedules#generate_blog_rotation'

  post 'schedules/update_holidays' => 'schedules#update_holidays'

  post 'get_new_posts' => 'cohorts#get_new_posts'

  get 'get_new_posts_for_user' => 'users#get_new_posts'

  patch 'blogs/:id/reset' => 'blogs#reset', as: 'reset_blog'

  post 'set_blog_rotation' => 'schedules#set_blog_rotation'

  match 'login', to: redirect('/auth/github'), via: [:get, :post]

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  
  get 'logout' => 'sessions#destroy'

  get 'publish_post' => 'posts#publish_post'

  get 'feature_post' => 'posts#feature_post'

  get 'publish_posts' => 'posts#publish_posts'

  post 'set_default_holidays' => 'holidays#set_default_holidays'
end
