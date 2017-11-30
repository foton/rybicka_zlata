# frozen_string_literal: true

require 'test_helper'

class DiscussionServiceTest < ActiveSupport::TestCase
  def setup
    setup_wish
    create_connection_for(@donor, name: 'donor_to_author', email: @author.email)
  end

  def test_can_add_post_from_donor
    service = DiscussionService.new(@wish, @donor)
    assert service.posts.empty?

    assert service.can_add_post?
    assert service.add_post(content: 'donor post')
    assert_equal 1, service.posts.size
    last_post = service.posts.last
    assert_equal 'donor post', last_post.content
    assert_equal @donor, last_post.author
    refute last_post.show_to_anybody?  # default: not show
  end

  def test_allow_post_from_author_if_discussion_is_open_to_donees
    service = DiscussionService.new(@wish, @author)
    assert service.posts.empty?

    assert_raises(DiscussionService::NotAuthorizedError) { service.add_post(content: 'author post') }
    refute service.can_add_post?

    open_discussion_to_donees
    add_secret_post_from_donor

    assert service.can_add_post?
    assert service.add_post(content: 'author post')
    assert_equal 2, service.posts.size
    last_post = service.posts.last
    assert_equal 'author post', last_post.content
    assert_equal @author, last_post.author
    assert last_post.show_to_anybody?  # forced for donees
    assert service.posts.select { |p| p.content == 'donor secret post' }.empty?
  end

  def test_allow_post_from_donee_if_discussion_is_open_to_donees
    service = DiscussionService.new(@wish, @donee)
    assert service.posts.empty?

    assert_raises(DiscussionService::NotAuthorizedError) { service.add_post(content: 'donee post') }
    refute service.can_add_post?

    open_discussion_to_donees
    add_secret_post_from_donor

    assert service.can_add_post?
    assert service.add_post(content: 'donee post')
    assert_equal 2, service.posts.size
    last_post = service.posts.last
    assert_equal 'donee post', last_post.content
    assert_equal @donee, last_post.author
    assert last_post.show_to_anybody?  # forced for donees
    assert service.posts.select { |p| p.content == 'donor secret post' }.empty?
  end

  def open_discussion_to_donees
    service = DiscussionService.new(@wish, @donor)
    assert service.add_post(content: 'donor non secret post',
                            show_to_anybody: true)
    assert service.posts.last.show_to_anybody?
  end

  def add_secret_post_from_donor
    service = DiscussionService.new(@wish, @donor)
    assert service.add_post(content: 'donor secret post')
  end
end
