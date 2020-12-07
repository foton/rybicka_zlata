# frozen_string_literal: true

require 'test_helper'

class DiscussionServiceTest < ActiveSupport::TestCase
  attr_reader :wish, :author, :donee, :donor
  def setup
    @wish = wishes(:lisa_bart_bigger_car)
    @author = users(:lisa)
    assert @wish.author, @author

    @donee = users(:bart)
    @donor = users(:homer)
  end

  def test_can_add_post_from_donor_without_restriction
    service = DiscussionService.new(wish, donor)
    assert service.posts.empty?

    assert service.can_add_post?

    add_secret_post_from_donor

    assert_equal 1, service.posts.size
    last_post = service.posts.last
    assert_equal 'donor secret post', last_post.content
    assert_equal donor, last_post.author
    assert_not last_post.show_to_anybody? # default: not show
  end

  def test_allow_post_from_author_if_discussion_is_open_to_donees
    service = DiscussionService.new(wish, author)
    assert service.posts.empty?

    assert_raises(DiscussionService::NotAuthorizedError) { service.add_post(content: 'author post') }
    assert_not service.can_add_post?

    open_discussion_to_donees
    add_secret_post_from_donor

    assert service.can_add_post?
    assert service.add_post(content: 'author post')
    assert_equal 2, service.posts.size
    last_post = service.posts.last
    assert_equal 'author post', last_post.content
    assert_equal author, last_post.author
    assert last_post.show_to_anybody?  # forced for donees
    assert service.posts.select { |p| p.content == 'donor secret post' }.empty?
  end

  def test_allow_post_from_donee_if_discussion_is_open_to_donees
    service = DiscussionService.new(wish, donee)
    assert service.posts.empty?

    assert_raises(DiscussionService::NotAuthorizedError) { service.add_post(content: 'donee post') }
    assert_not service.can_add_post?

    open_discussion_to_donees
    add_secret_post_from_donor

    assert service.can_add_post?
    assert service.add_post(content: 'donee post')
    assert_equal 2, service.posts.size
    last_post = service.posts.last
    assert_equal 'donee post', last_post.content
    assert_equal donee, last_post.author
    assert last_post.show_to_anybody?  # forced for donees
    assert service.posts.select { |p| p.content == 'donor secret post' }.empty?
  end

  def test_know_which_post_can_be_deleted
    open_discussion_to_donees

    service = DiscussionService.new(wish, donee)

    assert service.add_post(content: 'donee post')
    assert service.can_delete_post?(service.posts.last)

    add_secret_post_from_donor
    assert_not service.can_delete_post?(service.posts.last)
  end

  def test_deleting_post_notify_everyone_for_public_post
    open_discussion_to_donees

    post_to_anybody = Discussion::Post.last
    assert post_to_anybody.show_to_anybody?
    assert_equal donor, post_to_anybody.author

    service = DiscussionService.new(wish, donor) # can be post.author or admin
    assert_difference('ActivityNotification::Notification.count', (wish.donor_users + wish.donee_users ).size) do
      service.delete_post(post_to_anybody)
    end

    (wish.donor_users + wish.donee_users).each do |user|
      assert user.notifications.where(key: 'post.deleted', notifiable: post_to_anybody).exists?, "There should be notification for user #{user.to_json}"
    end
  end


  def test_deleting_post_notify_all_donors_for_secret_post
    add_secret_post_from_donor
    post_to_donors = Discussion::Post.last
    assert_not post_to_donors.show_to_anybody?

    service = DiscussionService.new(wish, users(:porybny)) # can be post.author or admin
    assert_difference('ActivityNotification::Notification.count', wish.donor_users.size) do
      service.delete_post(post_to_donors)
    end

    (wish.donor_users).each do |donor|
      assert donor.notifications.where(key: 'post.deleted', notifiable: post_to_donors).exists?, "There should be notification for donor #{donor.to_json}"
    end
  end

  private

  def open_discussion_to_donees
    service = DiscussionService.new(wish, donor)
    assert_difference('ActivityNotification::Notification.count', (wish.donor_users - [donor] + wish.donee_users ).size) do
      assert service.add_post(content: 'donor non secret post',
                              show_to_anybody: true)
    end

    last_post = service.posts.last
    assert last_post.show_to_anybody?

    (wish.donor_users - [donor] + wish.donee_users).each do |user|
      assert user.notifications.where(key: 'post.created', notifiable: last_post).exists?, "There should be notification for user #{user.to_json}"
    end
  end

  def add_secret_post_from_donor
    service = DiscussionService.new(wish, donor)
    assert_difference('ActivityNotification::Notification.count', (wish.donor_users - [donor]).size) do
      assert service.add_post(content: 'donor secret post')
    end

    last_post = service.posts.last
    assert_not last_post.show_to_anybody?

    (wish.donor_users - [donor]).each do |donor|
      assert donor.notifications.where(key: 'post.created', notifiable: last_post).exists?, "There should be notification for donor #{donor.to_json}"
    end
  end
end
