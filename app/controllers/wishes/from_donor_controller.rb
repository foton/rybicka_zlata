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

    wish_updater = WishUpdater.call(@wish, wish_params.to_h, @user)
    @wish = wish_updater.result.wish

    respond_to do |format|
      if wish_updater.success?
        flash[:notice] = wish_updater.result.message
        format.html { redirect_to user_others_wish_url(@user, @wish) }
        format.js   { render '/wishes/state_update.js.erb' }
      else
        flash[:error] = t('wishes.from_donor.views.not_updated', title: @wish.title)
        @user = @wish.author
        format.html { render action: 'show' }
      end
    end
  end

  private

  def load_wishes
    @wishes_by_donees = Wish::ListByDonees.new(@user)
  end

  def load_wish
    @wish ||= wish_scope.find(params[:id])
  end

  def wish_params
    @wish_params ||= params.permit(:state_action)
  end

  def wish_scope
    @user.donor_wishes.not_fulfilled
  end
end
