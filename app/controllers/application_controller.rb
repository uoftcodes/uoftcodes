# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def after_sign_in_path_for(_resource_or_scope)
    login_redirect = session[:login_redirect] || '/events'

    session.delete(:login_redirect)

    login_redirect
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
