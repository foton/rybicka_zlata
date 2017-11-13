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

    assert service.add_post(content: 'donor post')
    assert_equal 1, service.posts.size
    assert_equal 'donor post', service.posts.last.content
    assert_equal @donor, service.posts.last.author
  end

  def test_allow_post_from_author_if_post_to_donnees_exists
    service = DiscussionService.new(@wish, @author)
    assert service.posts.empty?

    assert_raises(DiscussionService::NotAuthorizedError) { service.add_post(content: 'author post') }

    open_discussion_to_donees
    add_secret_post_from_donor

    assert service.add_post(content: 'author post')
    assert_equal 2, service.posts.size
    assert_equal 'author post', service.posts.last.content
    assert_equal @author, service.posts.last.author
    assert service.posts.select { |p| p.content == 'donor secret post' }.empty?
  end

  def test_allow_post_from_donee_if_post_to_donnees_exists
    service = DiscussionService.new(@wish, @donee)
    assert service.posts.empty?

    assert_raises(DiscussionService::NotAuthorizedError) { service.add_post(content: 'donee post') }

    open_discussion_to_donees
    add_secret_post_from_donor

    assert service.add_post(content: 'donee post')
    assert_equal 2, service.posts.size
    assert_equal 'donee post', service.posts.last.content
    assert_equal @donee, service.posts.last.author
    assert service.posts.select { |p| p.content == 'donor secret post' }.empty?
  end

  def open_discussion_to_donees
    service = DiscussionService.new(@wish, @donor)
    assert service.add_post(content: 'donor non secret post',
                            show_to_anybody: true)
  end

  def add_secret_post_from_donor
    service = DiscussionService.new(@wish, @donor)
    assert service.add_post(content: 'donor secret post')
  end
end
