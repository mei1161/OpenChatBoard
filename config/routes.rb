Rails.application.routes.draw do
  resources :recruitments do
    resources :recruitment_comments
  end

  root to: 'post#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
