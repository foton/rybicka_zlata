# frozen_string_literal: true

require 'test_helper'
module Discussions
  class PostsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    def setup
      @controller = Discussions::PostsController.new
      @request.env['devise.mapping'] = Devise.mappings[:user]
      setup_wish
    end

    def teardown
      wish.posts.delete_all
    end

    def test_create_as_donor
      sign_in @donor
      discussion_service = DiscussionService.new(wish, @donor)
      post_h = { content: 'Donor comment to this wish', wish_id: wish.id }

      post :create, params: { post: post_h }

      assert_response :redirect
      anchor = discussion_service.posts.last.anchor
      assert_redirected_to user_others_wish_path(@donor, wish, anchor: anchor)
    end

    def test_create_for_donee_is_allowed_only_on_opened_discussion
      sign_in @donee
      discussion_service = DiscussionService.new(wish, @donee)
      post_h = { content: 'donee comment to this wish', wish_id: wish.id }

      post :create, params: { post: post_h }

      assert_response :redirect
      assert_equal 'You are not authorized to access this page.', flash[:error]
      assert wish.posts.count.zero?

      open_discussion_to_donees
      post :create, params: { post: post_h }

      assert_response :redirect
      anchor = discussion_service.posts.last.anchor
      assert_redirected_to user_my_wish_path(@donee, wish, anchor: anchor)
    end

    private

    def wish
      @wish
    end

    def open_discussion_to_donees
      service = DiscussionService.new(wish, @donor)
      assert service.add_post(content: 'donor non secret post',
                            show_to_anybody: true)
    end

  end
end
