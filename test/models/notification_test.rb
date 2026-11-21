# frozen_string_literal: true

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  def setup
    @wish = wishes(:marge_homer_holidays)
    @marge = users(:marge)
  end

  def test_notify_creates_one_notification_per_target_of_the_group # rubocop:disable Metrics/AbcSize
    @wish.updated_by = @marge
    targets = @wish.notification_targets(:donors)
    assert targets.any?

    notifications = assert_difference('Notification.count', targets.size) do
      @wish.notify(:donors, key: 'wish.updated', notifier: @marge)
    end
    assert_equal targets.sort_by(&:id), notifications.map(&:target).sort_by(&:id)
    assert(notifications.all? { |n| n.notifiable == @wish && n.notifier == @marge && n.unopened? })
  end

  def test_unknown_group
    assert_raises(ArgumentError) { @wish.notify(:strangers, key: 'wish.updated') }
  end

  def test_open_and_open_all_and_unopened_count # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    user = users(:bart)
    first, second = 2.times.map do
      Notification.create!(target: user, notifiable: @wish, key: 'wish.updated')
    end
    assert_equal 2, user.unopened_notification_count

    first.open!
    assert first.opened?
    assert_equal 1, user.unopened_notification_count

    user.notifications.open_all!
    assert second.reload.opened?
    assert_equal 0, user.unopened_notification_count
  end

  def test_wish_of_a_post_notification
    post = Discussion::Post.create!(wish: @wish, author: @marge, content: 'hi')
    assert_equal @wish, Notification.new(notifiable: post).wish
  end
end
