# frozen_string_literal: true

# this serves as redirectional manager for current user and wish_id
class Wishes::BaseController < ApplicationController
  include WishesHelper

  before_action :set_redirect_path

  def show

    redirect_to @redirect_path
  end

  def set_redirect_path
    wish = params[:id].present? ? Wish.find_by(id: params[:id]) : nil
    @redirect_path = path_to_wish_action_for_user(params[:action], current_user, wish, {})
    if @redirect_path.blank?
      flash[:error] = I18n.t('you_do_not_have_access')
      @redirect_path = my_profile_path
    end
  end
end
