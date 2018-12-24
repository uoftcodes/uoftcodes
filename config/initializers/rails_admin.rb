# frozen_string_literal: true

RailsAdmin.config do |config|
  config.main_app_name = ['UofTCodes']

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
      field :skip_confirmation, :boolean
    end
  end

  config.authorize_with do
    if current_user.nil?
      store_location_for(:user, request.fullpath)
      redirect_to '/users/sign_in'
    elsif !current_user.admin?
      flash[:notice] = 'You do not have the permissions to view this page.'
      redirect_to '/'
    end
  end
end
