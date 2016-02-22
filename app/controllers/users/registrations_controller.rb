class Users::RegistrationsController < Devise::RegistrationsController
  #https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb

  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    #create action
    devise_parameter_sanitizer.for(:sign_up).push( :locale, :time_zone, :name)
    #update action
    devise_parameter_sanitizer.for(:account_update).push( :locale, :time_zone, :name)
    set_minimum_password_length
  end

  def after_update_path_for(resource)
    my_profile_path
  end  
end
