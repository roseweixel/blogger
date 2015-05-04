Rails.application.routes.draw do
  root 'welcome#index'

  resources :cohorts do 
    resources :blogs
    resources :students
  end
end
