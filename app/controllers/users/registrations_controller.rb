# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    # def create
    #   super
    # end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    def update
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      if params[:user][:password].present?
        resource_updated = resource.update_with_password(account_update_params)
      else
        passwordless_params = account_update_params
        passwordless_params.delete(:current_password)

        resource_updated = resource.update_without_password(passwordless_params)
      end

      yield resource if block_given?
      if resource_updated
        if is_flashing_format?
          flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
          set_flash_message :notice, flash_key
        end
        bypass_sign_in resource, scope: resource_name
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    def after_update_path_for(_resource)
      edit_user_registration_path
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name student_number])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name student_number])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   new_user_session_path
    # end

    # The path used after sign up for inactive accounts.
    def after_inactive_sign_up_path_for(_resource)
      new_user_session_path
    end
  end
end
