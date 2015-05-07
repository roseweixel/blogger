Rails.application.routes.draw do
  root 'welcome#index'

  resources :blogs

  resources :cohorts do 
    resources :students
    resources :schedules do
      resources :blog_assignments
    end
  end

  post 'generate_blog_rotation' => 'schedules#generate_blog_rotation'
end
