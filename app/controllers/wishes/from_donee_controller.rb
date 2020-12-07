# frozen_string_literal: true

class Wishes::FromDoneeController < ApplicationController
  before_action :set_user

  def index
    load_wishes
    if params[:fulfilled].to_i == 1
      @wishes = @wishes.fulfilled
      render 'index_fulfilled'
    else
      @wishes = @wishes.not_fulfilled
      render 'index'
    end
  end

  def show
    load_wish
    @discussion_service = DiscussionService.new(@wish, current_user)
  end

  def edit
    load_wish
    load_user_connections
    load_user_groups
  end

  def update
    load_wish
    load_user_connections
    load_user_groups

    wish_updater = WishUpdater.call(@wish, wish_params.to_h, @user)
    @wish = wish_updater.result.wish

    respond_to do |format|
      if wish_updater.success?
        flash[:notice] = wish_updater.result.message || updated_message
        format.html { redirect_to user_my_wish_url(@user, @wish) }
        format.js do
          if @wish.fulfilled?
            render 'fulfilled_or_destroyed.js.erb'
          else
            render '/wishes/state_update.js.erb'
          end
        end
      else
        flash[:error] = not_updated_message
        @user = @wish.author
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    load_wish
    destroy_wish
    respond_to do |format|
      format.html { redirect_to user_my_wishes_url(@user), status: :see_other, format: :html }
      format.js   { render 'fulfilled_or_destroyed.js.erb', layout: false }
    end
  end

  private

  def load_wishes
    @wishes ||= wish_scope
  end

  def load_wish
    @wish ||= wish_scope.find(params[:id])
  end

  def destroy_wish
    if @wish.destroy(@user)
      flash[:notice] = t('wishes.from_donee.views.deleted', title: @wish.title)
    else
      flash[:error] = t('wishes.from_donee.views.not_deleted', title: @wish.title)
    end
  end

  def wish_params
    @wish_params ||= begin
      wish_params = params[:wish] || ActionController::Parameters.new({})
      wish_params.delete(:unused_conn_ids)
      wish_params[:donor_conn_ids] = wish_params[:donor_conn_ids].blank? ? [] : wish_params[:donor_conn_ids].collect(&:to_i)
      wish_params[:state_action] = params[:state_action]
      wish_params.permit(:title, :description, :state_action, donor_conn_ids: [])
    end
  end

  def wish_scope
    # here I can solve authorization to access objects
    # user can manage only it's own wishs
    @user.donee_wishes
  end

  def load_user_connections
    @user_connections = @user.friend_connections
    @available_donor_connections = @wish.available_donor_connections_from(@user_connections)
  end

  def load_user_groups
    @user_groups = @user.groups.includes(:connections)
    @available_donor_groups = @wish.available_user_groups_from(@user, @available_donor_connections)
  end

  def updated_message
    t('wishes.from_donee.views.updated', title: @wish.title)
  end

  def not_updated_message
    t('wishes.from_donee.views.not_updated', title: @wish.title)
  end
end
