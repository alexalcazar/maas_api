# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    get '/clients', to: 'clients#show'
    resources :schedules, only: %i[show create update]
  end
end
