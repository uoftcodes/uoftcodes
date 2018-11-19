# frozen_string_literal: true

require 'rails_admin/engine'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :events do
    post 'approve', action: :approve
  end
end
