# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!

  private

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def unauthorized_redirect
    flash[:alert] = 'You are unauthorized to visit that page.'
    redirect_to events_path
  end

  def authorize_only_like_lecturer!
    unauthorized_redirect unless current_user.like_lecturer?
  end

  def authorize_only_admin!
    unauthorized_redirect unless current_user.admin?
  end
end
