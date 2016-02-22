class Users::OmniAuthController < Devise::OmniauthCallbacksController

  # def self.default_url_options(options={})
  #   options.delete(:locale)
  #   options
  # end

  def google
    @user = User.find_or_create_from_omniauth!(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def github
    @user = User.find_or_create_from_omniauth!(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "GithHub"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def facebook
    @user = User.find_or_create_from_omniauth!(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    logger.debug("omniauth.auth=#{request.env["omniauth.auth"]}")
    @user = User.find_or_create_from_omniauth!(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    logger.debug("omniauth.auth=#{request.env["omniauth.auth"]}")
    @user = User.find_or_create_from_omniauth!(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "LinkedIn"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  protected
    def after_sign_up_path_for(resource)
      my_profile_path
    end

end
