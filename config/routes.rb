# frozen_string_literal: true

require 'rails_admin/engine'

Rails.application.routes.draw do
  root 'homepage#homepage'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :events do
    post 'approve', action: :approve
  end

  resources :lecturer_applications
end
