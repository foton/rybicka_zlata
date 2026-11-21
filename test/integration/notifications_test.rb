# frozen_string_literal: true

require 'test_helper'

class NotificationsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @bart = users(:bart)
    @wish = wishes(:marge_homer_holidays)
    @unread = Notification.create!(target: @bart, notifiable: @wish, key: 'wish.updated',
                                   notifier: users(:marge))
    @read = Notification.create!(target: @bart, notifiable: @wish, key: 'wish.updated',
                                 opened_at: 1.hour.ago)
    sign_in @bart
  end

  def test_index_lists_unread_and_read_notifications
    get user_notifications_path(@bart)

    assert_response :ok
    assert_select ".notification_#{@unread.id}.rz-notification--unopened form[action*='/open']"
    assert_select ".notification_#{@read.id}.opened a[href*='/move']"
    assert_select 'form[action*="/open_all"] button.open_all'
  end

  def test_open_with_move_marks_read_and_goes_to_the_wish
    put open_user_notification_path(@bart, @unread, move: true)

    assert_redirected_to wish_path(@wish, locale: :cs)
    assert @unread.reload.opened?
  end

  def test_open_all
    post open_all_user_notifications_path(@bart)

    assert_redirected_to user_notifications_path(@bart, locale: :cs)
    assert_equal 0, @bart.unopened_notification_count
  end

  def test_notification_of_a_post_goes_to_the_post_in_the_discussion
    post_ = Discussion::Post.create!(wish: @wish, author: users(:marge), content: 'hi')
    notification = Notification.create!(target: @bart, notifiable: post_, key: 'post.created')

    get move_user_notification_path(@bart, notification)
    assert_redirected_to wish_path(@wish, anchor: post_.anchor, locale: :cs)
  end

  def test_notifications_of_other_users_are_not_accessible
    lisa = users(:lisa)
    foreign = Notification.create!(target: lisa, notifiable: @wish, key: 'wish.updated')

    get user_notifications_path(lisa)
    assert_response :redirect
    assert_match I18n.t('peeking_is_not_allowed'), flash[:error]

    put open_user_notification_path(@bart, foreign) # only own notifications are found
    assert_response :not_found
    assert foreign.reload.unopened?
  end
end
