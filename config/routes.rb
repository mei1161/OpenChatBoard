Rails.application.routes.draw do
  get 'recruitments/index'
  root to: 'post#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
