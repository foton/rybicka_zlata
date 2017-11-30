# frozen_string_literal: true

class Wishes::FromDonorController < ApplicationController
  before_action :set_user

  def index
    load_wishes
  end

  def show
    load_wish
    @discussion_service = DiscussionService.new(@wish, current_user)
  end

  def update
    load_wish
    updated_message = build_wish # update wish from params
    save_wish(updated_message, not_updated_message)
  end

  private

  def load_wishes
    @wishes_by_donees = Wish::ListByDonees.new(@user)
  end

  def load_wish
    @wish ||= wish_scope.find(params[:id])
  end

  def build_wish
    msg = @wish.send("#{wish_params[:state_action]}!", @user) if wish_params[:state_action].present? && @wish.available_actions_for(@user).include?(wish_params[:state_action].to_sym)
  end

  def save_wish(msg_ok, msg_bad)
    respond_to do |format|
      if @wish.save
        flash[:notice] = msg_ok
        format.html { redirect_to user_others_wish_url(@user, @wish) }
        format.js   { render '/wishes/state_update.js.erb' }
      else
        flash[:error] = msg_bad
        @user = @wish.author
        format.html { render action: 'show' }
      end
    end
  end

  def wish_params
    @wish_params ||= (params.permit(:state_action) || ActionController::Parameters.new({}))
  end

  def wish_scope
    @user.donor_wishes.not_fulfilled
  end

  def not_updated_message
    t('wishes.from_donor.views.not_updated', title: @wish.title)
  end
end
