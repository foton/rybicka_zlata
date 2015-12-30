class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  before_action :authenticate_user!, except: [:home,:change_locale]
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || (current_user && current_user.locale) || I18n.default_locale
  end

  def self.default_url_options(options={})
    options.merge({ :locale => I18n.locale })
  end
end
