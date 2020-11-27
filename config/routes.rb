Rails.application.routes.draw do
  
  root to: 'imports#new'
  resources :imports, only: [:new, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
