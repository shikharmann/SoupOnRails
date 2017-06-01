Rails.application.routes.draw do

  # Sidekiq routes
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # ActivaAdmin routes
  ActiveAdmin.routes(self)
  # Root routes
  root to: 'emails#activate'

  post '/emails/update', to: 'emails#update'


end
