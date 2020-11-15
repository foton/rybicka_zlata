# frozen_string_literal: true

require 'test_helper'

class WishCreatorTest < ActiveSupport::TestCase
  attr_reader :author, :donor_conns, :donee_conns, :valid_params

  def setup
    @author = users(:bart)

    bart_to_marge_conn = connections(:bart_to_marge)
    bart_to_homer_conn = connections(:bart_to_homer)
    bart_to_lisa_conn = connections(:bart_to_lisa)
    homer_to_marge_conn = connections(:homer_to_marge)
    @donor_conns = [bart_to_marge_conn, bart_to_lisa_conn]
    @donee_conns = [bart_to_homer_conn]

    @valid_params = {
      title: 'A special wish',
      description: 'wish me luck for tomorow!',
      donee_conn_ids: donee_conns.collect(&:id),
      donor_conn_ids: donor_conns.collect(&:id) }.merge(user_id: author.id)
  end

  test 'can create wish and notify users' do
    wish_params = valid_params
    service = assert_difference('ActivityNotification::Notification.count', (donor_conns + donee_conns).size) do
      WishCreator.call(wish_params, author)
    end

    assert service.success?

    new_wish = service.result
    assert_equal wish_params[:title], new_wish.title
    assert_equal wish_params[:description], new_wish.description
    assert new_wish.persisted?
    assert_equal donor_conns.sort, new_wish.donor_connections.sort
    assert_equal (donee_conns + [author.base_connection]).sort, new_wish.donee_connections.sort
    assert_equal author, new_wish.author
    assert_equal author, new_wish.updated_by

    assert_notified(users: donee_conns.collect(&:friend), key: 'wish.notifications.created.you_as_donee', notifier: author, notifiable: new_wish)
    assert_notified(users: donor_conns.collect(&:friend), key: 'wish.notifications.created.you_as_donor', notifier: author, notifiable: new_wish)
  end

  test 'can fails on creation' do
    wish_params = valid_params
    wish_params[:title] = ""

    service = assert_no_difference('ActivityNotification::Notification.count') do
      WishCreator.call(wish_params, author)
    end

    assert service.failed?
    assert_equal ["Error on creating wish, see wish.errors"], service.errors

    new_wish = service.result
    assert_not new_wish.persisted?
    assert_equal ["je povinná položka"], new_wish.errors[:title]

    assert_equal wish_params[:title], new_wish.title
    assert_equal wish_params[:description], new_wish.description
    assert_equal donor_conns.sort, new_wish.donor_connections.sort
    assert_equal (donee_conns + [author.base_connection]).sort, new_wish.donee_connections.sort
    assert_equal author, new_wish.author
    assert_equal author, new_wish.updated_by
  end

  def assert_notified(users:, key:, notifier:, notifiable:)
      users.each do |target|
        assert target.notifications.where(notifiable: notifiable, notifier: notifier).filtered_by_key(key).exists?,
               "Notification for #{target} for #{key} not found between #{target.notifications}"
      end
    end
end
