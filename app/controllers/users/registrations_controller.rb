class Users::RegistrationsController < Devise::RegistrationsController
  #https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb

  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push( :locale, :time_zone)
  end
end
