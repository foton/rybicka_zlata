# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb

  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    # create action
    devise_parameter_sanitizer.permit(:sign_up, keys: above_devise_keys)
    # update action
    devise_parameter_sanitizer.permit(:account_update, keys: above_devise_keys)
    set_minimum_password_length
  end

  def after_update_path_for(_resource)
    my_profile_path
  end

  def above_devise_keys
    %i[locale time zone name
       body_height body_weight tshirt_size
       trousers_waist_size trousers_leg_size shoes_size
       other_sizes_and_dimensions
       likes dislikes]
  end
end
