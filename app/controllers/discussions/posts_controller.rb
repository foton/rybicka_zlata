# frozen_string_literal: true
module Discussions
  class PostsController < ApplicationController
    include WishesHelper

    def create
      begin
        @post = discussion_service.add_post(post_hash)
        redirect_to path_to_wish_action_for_user(:show, current_user, @wish, anchor: @post.anchor)
      rescue DiscussionService::NotAuthorizedError
        raise User::NotAuthorized
      end
    end

    def edit
      load_post
    end

    def update
      load_wish
      build_post
      # save_group(t('groups.views.updated', name: @group.name), t('groups.views.not_updated', name: @group.name)) || render('edit')
    end

    def destroy
      load_post
      destroy_post
      redirect_to wish_url(@wish) #TODO: last post?
    end

    private

    def discussion_service
      @service ||= DiscussionService.new(load_wish, current_user)
    end

    def load_wish
      @wish ||= (current_user.donee_wishes.where(id: post_params[:wish_id]) \
                 + current_user.donor_wishes.where(id: post_params[:wish_id])).compact.first
    end

    def load_post
      load_wish
      @post ||= discussion_service.post_available_for(current_user).find(params[:id])
    end

    def build_post
      load_wish
      @post ||= discussion_service.add_post()
      @post.post_attributes = post_params
      @post.user = current_user
    end

    # def save_group(msg_ok, msg_bad)
    #   if @group.save
    #     flash[:notice] = msg_ok
    #     redirect_to user_group_url(current_user, @group)
    #     true
    #   else
    #     flash[:error] = msg_bad
    #     @new_contact = @group
    #     current_user = @group.user
    #     false
    #   end
    # end

    # def create_group(msg_ok, msg_bad)
    #   if @group.save
    #     flash[:notice] = msg_ok
    #     redirect_to edit_user_group_url(current_user, @group) # to add connections
    #     true
    #   else
    #     flash[:error] = msg_bad
    #     @new_contact = @group
    #     current_user = @group.user
    #     false
    #   end
    # end

    # def destroy_group
    #   if @group.destroy
    #     flash[:notice] = t('groups.views.deleted', name: @group.name)
    #   else
    #     flash[:error] = t('groups.views.not_deleted', name: @group.name)
    #   end
    # end

    def post_params
      params[:discussion_post].permit(:content, :show_to_anybody, :wish_id)
    end

    def post_hash
      post_params.slice(:content, :show_to_anybody)
    end
    # def group_scope
    #   # here I can solve authorization to access objects
    #   # user can manage only it's own groups
    #   Group.where(user_id: current_user.id)
    # end

    # def load_user_connections
    #   current_user_connections = current_user.friend_connections
    # end
  end
end
