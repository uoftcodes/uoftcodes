# frozen_string_literal: true

RailsAdmin.config do |config|
  config.actions do
    dashboard
    index
    new
    show
    edit
    delete
  end

  config.model 'User' do
    list do
      field :first_name
      field :last_name
      field :email
      field :user_type
    end

    edit do
      field :first_name
      field :last_name
      field :email
      field :password
      field :password_confirmation
      field :user_type
    end
  end

  config.authorize_with do
    if current_user.nil?
      session[:login_redirect] = '/admin'
      redirect_to '/users/sign_in'
    elsif !current_user.admin?
      flash[:notice] = 'You do not have the permissions to view this page.'
      redirect_to '/'
    end
  end
end
