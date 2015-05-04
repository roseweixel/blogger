Rails.application.routes.draw do
  root 'blogs#index'

  resources :blogs

  resources :cohorts do 
    resources :students
  end
end
