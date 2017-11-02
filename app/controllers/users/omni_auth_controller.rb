# frozen_string_literal: true

class Users::OmniAuthController < Devise::OmniauthCallbacksController
  # def self.default_url_options(options={})
  #   options.delete(:locale)
  #   options
  # end

  def google
    set_user_from_omniauth('google', 'Google')
  end

  def github
    set_user_from_omniauth('github', 'GitHub')
  end

  def facebook
    set_user_from_omniauth('facebook', 'Facebook')
  end

  def twitter
    set_user_from_omniauth('twitter', 'Twitter')
  end

  def linkedin
    set_user_from_omniauth('linkedin', 'LinkedIn')
  end

  protected

  def after_sign_up_path_for(_resource)
    my_profile_path
  end

  def set_user_from_omniauth(provider_id, provider_name)
    @user, password = User.find_or_create_from_omniauth!(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: provider_name
      flash[:warning] = I18n.t('user.temporary_password_is_set_to', password: password) if password.present?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.' + provider_id + '_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
