# frozen_string_literal: true

require 'rails_admin/engine'
require 'sidekiq/web'

Rails.application.routes.draw do
  root 'homepage#homepage'

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'events/archived', to: 'events#archived_index'
  resources :events do
    post 'approve', action: :approve
    post 'register', action: :register
  end

  resources :lecturer_applications
end
