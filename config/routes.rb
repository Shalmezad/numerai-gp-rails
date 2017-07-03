require 'resque/server'
Rails.application.routes.draw do
  resources :export_files
  resources :generation_stats
  resources :dashboard
  resources :demes do
    member do
      get 'stop'
    end
    resources :programs
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Resque::Server.new, :at => "/resque"
end
