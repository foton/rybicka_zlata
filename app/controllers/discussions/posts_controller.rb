# frozen_string_literal: true

module Discussions
  class PostsController < ApplicationController
    include WishesHelper

    def create
      @post = discussion_service.add_post(post_hash)
      redirect_to path_to_wish_action_for_user(:show, current_user, @wish, anchor: @post.anchor)
    rescue DiscussionService::NotAuthorizedError
      raise User::NotAuthorized
    end

    def destroy
      load_post
      begin
        last_post = discussion_service.delete_post(@post)
        redirect_to path_to_wish_action_for_user(:show,
                                                 current_user,
                                                 @wish,
                                                 anchor: last_post&.anchor || 'discussion')
      rescue DiscussionService::NotAuthorizedError
        raise User::NotAuthorized
      end
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
      @post ||= discussion_service.posts.find(params[:id])
    end

    def post_params
      if params[:id].present? && params[:discussion_post].blank?
        params[:discussion_post] = { wish_id: DiscussionService.find_post(params[:id]).wish_id }
      end

      params[:discussion_post].permit(:content, :show_to_anybody, :wish_id)
    end

    def post_hash
      post_params.slice(:content, :show_to_anybody)
    end
  end
end
