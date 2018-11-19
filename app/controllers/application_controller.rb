# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def after_sign_in_path_for(_resource_or_scope)
    login_redirect = session[:login_redirect] || '/events'

    session.delete(:login_redirect)

    login_redirect
  end
end
