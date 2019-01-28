# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_user, except: [:my, :infos]

  def my
    @user = current_user
    show
  end

  def show
    if @user.email.match?(User::Identity::TWITTER_FAKE_EMAIL_REGEXP)
      flash[:notice] = flash[:notice]
      flash[:warning] = flash[:warning]
      flash[:error] = flash[:error].to_s + " \n" + I18n.t('user.identities.twitter_do_not_send_email_address')
      redirect_to edit_user_registration_url(@user)
    end
    @new_contact = User::Identity::AsContact.new(provider: User::Identity::LOCAL_PROVIDER, user: @user)
    render :show
  end

  def infos
    @user = User.find(params[:user_id])
    unless current_user_can_see_infos
      flash[:error] = I18n.t('peeking_is_not_allowed')
      redirect_to(not_peeking_url)
    end
  end

  private

  def not_peeking_url
    url_for(action: :my, params: { locale: I18n.locale })
  end

  def current_user_can_see_infos
    current_user == @user || current_user.connections.pluck(:friend_id).include?(@user.id) || current_user.admin?
  end
end
