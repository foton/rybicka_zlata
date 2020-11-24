# frozen_string_literal: true

require_relative 'from_donee_controller'

class Wishes::FromAuthorController < Wishes::FromDoneeController
  before_action :set_user

  def new
    @wish = @user.author_wishes.build
    load_user_connections
    load_user_groups
    @wish.author = @user
    @wish.donor_connections = @available_donor_connections
  end

  def create
    wish_creator = WishCreator.call(wish_params, @user)
    @wish = wish_creator.result

    load_user_connections
    load_user_groups

    if wish_creator.success?
      flash[:notice] = t('wishes.from_author.views.added', title: @wish.title)
      redirect_to user_my_wish_url(@user, @wish) # WishFromDonee controller ::show
    else
      flash[:error] = t('wishes.from_author.views.not_added', title: @wish.title)
      @user = @wish.author
      render('new')
    end
  end

  private

  def destroy_wish
    if @wish.destroy(@user)
      flash[:notice] = t('wishes.from_author.views.deleted', title: @wish.title)
    else
      flash[:error] = t('wishes.from_author.views.not_deleted', title: @wish.title)
    end
  end

  def wish_params
    @wish_params ||= begin
      wish_params = params[:wish] || ActionController::Parameters.new({})
      wish_params.delete(:unused_conn_ids)
      wish_params[:donee_conn_ids] = wish_params[:donee_conn_ids].blank? ? [] : wish_params[:donee_conn_ids].collect(&:to_i)
      wish_params[:donor_conn_ids] = wish_params[:donor_conn_ids].blank? ? [] : wish_params[:donor_conn_ids].collect(&:to_i)
      wish_params[:state_action] = params[:state_action]

      wish_params.permit(:title, :description, :state_action, donor_conn_ids: [], donee_conn_ids: [])
    end
  end

  def wish_scope
    # here I can solve authorization to access objects
    # user can manage only it's own wishs
    @user.author_wishes
  end

  def updated_message
    t('wishes.from_author.views.updated', title: @wish.title)
  end

  def not_updated_message
    t('wishes.from_author.views.not_updated', title: @wish.title)
  end

  def not_peeking_url
    user_my_wishes_url(current_user, params: { locale: I18n.locale })
  end
end
