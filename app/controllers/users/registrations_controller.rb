# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb

  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    # create action
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[locale time_zone name])
    # update action
    devise_parameter_sanitizer.permit(:account_update, keys: %i[locale time_zone name])
    set_minimum_password_length
  end

  def after_update_path_for(_resource)
    my_profile_path
  end
end
