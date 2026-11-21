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
        format.html do
          flash[:notice] = wish_updater.result.message
          redirect_to user_others_wish_url(@user, @wish)
        end
        format.turbo_stream do # list row actions
          flash.now[:notice] = wish_updater.result.message
          render 'wishes/state_update'
        end
      else
        not_updated = t('wishes.from_donor.views.not_updated', title: @wish.title)
        format.html do
          flash.now[:error] = not_updated
          @user = @wish.author
          render action: 'show'
        end
        format.turbo_stream do
          flash.now[:error] = not_updated
          render 'shared/snackbar_stream'
        end
      end
    end
  end

  private

  def load_wishes
    @wishes_by_donees = Wish::ListByDonees.new(@user)
  end

  def load_wish
    @wish ||= @user.donor_wishes.find(params[:id])
  end

  def wish_params
    @wish_params ||= params.permit(:state_action)
  end
end
