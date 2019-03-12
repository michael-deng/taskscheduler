Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks, :dependencies

  get '/schedule', to: 'tasks#schedule'

  root 'tasks#index'
end
