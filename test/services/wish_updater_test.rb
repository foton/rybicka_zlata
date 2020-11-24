# frozen_string_literal: true

require 'test_helper'

class WishUpdaterTest < ActiveSupport::TestCase
  attr_reader :original_attributes, :donor_conns, :donee_conns, :author_conn, :valid_params
  attr_accessor :wish, :updating_user, :original_attributes

  def setup
    @wish = wishes(:lisa_bart_bigger_car)

    @donor_conns = wish.donor_connections  # Homer have 2 connections here, From Lisa and from Bart
    @donee_conns = wish.donee_connections.select { |dc| !dc.base? }
    @author_conn = (wish.donee_connections.select { |dc| dc.base? }.first)

    @valid_params = {
      auhtor_id: users(:homer).id, # author cannot be changed!, this is for verifying it
      title: 'Updated title',
      description: 'Updated description' }
      # donee_conn_ids: donee_conns.collect(&:id),
      # donor_conn_ids: donor_conns.collect(&:id) }.merge(user_id: author.id)
  end

  test 'donor can book wish and notify other donors' do
    self.updating_user = wish.donor_users.first

    action = :book
    assert wish.available_actions_for(updating_user).include?(action)

    expected_notified_users = wish.donor_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(state_action: action.to_s), updating_user)
    end

    assert service.success?
    assert_equal I18n.t('wishes.actions.book.message', wish_title: wish.title, user_name: updating_user.name), service.result.message

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ booked_by_id: updating_user.id, state: Wish::State::STATE_RESERVED })

    assert_notified(users: expected_notified_users, key: 'wish.notifications.book', notifier: updating_user, notifiable: wish)
  end

  test 'donor can release booking and notify other donors' do
    self.updating_user = wish.donor_users.first
    wish.book!(updating_user)
    wish.save!

    action = :unbook
    assert wish.available_actions_for(updating_user).include?(action)

    expected_notified_users = wish.donor_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(state_action: action.to_s), updating_user)
    end

    assert service.success?
    assert_equal I18n.t('wishes.actions.unbook.message', wish_title: wish.title, user_name: updating_user.name), service.result.message

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ booked_by_id: nil, state: Wish::State::STATE_AVAILABLE })

    assert_notified(users: expected_notified_users, key: 'wish.notifications.unbook', notifier: updating_user, notifiable: wish)
  end

  test 'donor can mark wish as gifted and notify other donors' do
    self.updating_user = wish.donor_users.first
    wish.book!(updating_user)
    wish.save!

    action = :gifted
    assert wish.available_actions_for(updating_user).include?(action)

    expected_notified_users = wish.donor_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(state_action: action.to_s), updating_user)
    end

    assert service.success?
    assert_equal I18n.t('wishes.actions.gifted.message', wish_title: wish.title, user_name: updating_user.name), service.result.message

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ state: Wish::State::STATE_GIFTED })

    assert_notified(users: expected_notified_users, key: 'wish.notifications.gifted', notifier: updating_user, notifiable: wish)
  end

  test 'donor can call_for_donors and notify other donors' do
    self.updating_user = wish.donor_users.first

    action = :call_for_co_donors
    assert wish.available_actions_for(updating_user).include?(action)

    expected_notified_users = wish.donor_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(state_action: action.to_s), updating_user)
    end

    assert service.success?
    assert_equal I18n.t('wishes.actions.call_for_co_donors.message', wish_title: wish.title, user_name: updating_user.name), service.result.message

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ called_for_co_donors_by_id: updating_user.id, state: Wish::State::STATE_CALL_FOR_CO_DONORS })

    assert_notified(users: expected_notified_users, key: 'wish.notifications.call_for_co_donors', notifier: updating_user, notifiable: wish)
  end

  test 'donor can withdraw call_for_donors and notify other donors' do
    self.updating_user = wish.donor_users.first
    wish.call_for_co_donors!(updating_user)
    wish.save!

    action = :withdraw_call
    assert wish.available_actions_for(updating_user).include?(action)

    expected_notified_users = wish.donor_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(state_action: action.to_s), updating_user)
    end

    assert service.success?
    assert_equal I18n.t('wishes.actions.withdraw_call.message', wish_title: wish.title, user_name: updating_user.name), service.result.message

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ called_for_co_donors_by_id: nil, state: Wish::State::STATE_AVAILABLE })

    assert_notified(users: expected_notified_users, key: 'wish.notifications.withdraw_call', notifier: updating_user, notifiable: wish)
  end

  test 'donee can mark wish as fulfilled donors' do
    self.updating_user = users(:bart) # so it is not author
    #wish.call_for_co_donors!(updating_user)

    action = :fulfilled
    assert wish.available_actions_for(updating_user).include?(action)

    expected_notified_users = wish.donor_users + wish.donee_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(state_action: action.to_s), updating_user)
    end

    assert service.success?
    assert_equal I18n.t('wishes.actions.fulfilled.message', wish_title: wish.title, user_name: updating_user.name), service.result.message

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ state: Wish::State::STATE_FULFILLED, updated_by_donee_at: Time.current })

    assert_notified(users: expected_notified_users, key: 'wish.notifications.fulfilled', notifier: updating_user, notifiable: wish)
  end

  test 'donee can update donors' do
    self.updating_user = users(:bart) # donee_conns.first.friend # so it is not author
    assert updating_user != wish.author

    removed_donor_conn = connections(:bart_to_homer)
    other_conn = connections(:bart_to_milhouse)
    assert donor_conns.include?(removed_donor_conn)
    assert_not donor_conns.include?(other_conn)
    new_donor_conns = donor_conns - [removed_donor_conn] + [other_conn]

    expected_notified_users = wish.donor_users + wish.donee_users - [updating_user] + [removed_donor_conn.friend]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(donor_conn_ids: new_donor_conns.collect(&:id)), updating_user)
    end

    assert service.success?

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ donor_conns: new_donor_conns, updated_by_donee_at: Time.current })

    assert_notified(users: wish.donor_users + wish.donee_users - [updating_user], key: 'wish.notifications.updated', notifier: updating_user, notifiable: wish)
    # homer is still between donors, so no 'wish.notifications.removed_you_as_donor' is issued
  end


  test 'author can update wish attributes and notify users' do
    self.updating_user = wish.author #lisa

    expected_notified_users = wish.donor_users + wish.donee_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params, updating_user)
    end

    assert service.success?

    self.wish = service.result.wish # should be same as `Wish.find(wish.id)`
    # TODO: assert_equal("xxx", message, service.result.message
    assert_changes_only_on(valid_params.slice(:title, :description).merge({ updated_by_donee_at: Time.current }))

    assert_notified(users: expected_notified_users, key: 'wish.notifications.updated', notifier: updating_user, notifiable: wish)
  end

  test 'author can change donors' do
    self.updating_user = wish.author

    removed_donor_conn = connections(:lisa_to_marge)
    other_conn = connections(:lisa_to_maggie)
    assert donor_conns.include?(removed_donor_conn)
    assert_not donor_conns.include?(other_conn)
    new_donor_conns = donor_conns - [removed_donor_conn] + [other_conn]

    expected_notified_users = wish.donor_users + wish.donee_users - [updating_user] + [other_conn.friend]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(donor_conn_ids: new_donor_conns.collect(&:id)), updating_user)
    end

    assert service.success?

    self.wish = Wish.find(wish.id)
    assert_changes_only_on(valid_params.slice(:title, :description).merge({ donor_conns: new_donor_conns, updated_by_donee_at: Time.current }))

    assert_notified(users: expected_notified_users - [removed_donor_conn.friend], key: 'wish.notifications.updated', notifier: updating_user, notifiable: wish)
    assert_notified(users: [removed_donor_conn.friend], key: 'wish.notifications.removed_you_as_donor', notifier: updating_user, notifiable: wish)
  end

  test 'author can change donnees' do
    self.updating_user = wish.author

    # adding Milhouse to verify deletion of donors, who belongs to deleted donees
    assert_not_includes wish.donor_users, users(:milhouse)
    bart_to_milhouse_conn = connections(:bart_to_milhouse)
    wish.donor_connections << bart_to_milhouse_conn
    wish.instance_variable_set(:@donor_user_ids, nil)
    wish.instance_variable_set(:@donor_users, nil)
    assert_includes wish.reload.donor_users, users(:milhouse)

    existing_donee_conn = connections(:lisa_to_bart)
    other_conn = connections(:lisa_to_maggie)
    assert donee_conns.include?(existing_donee_conn)
    assert_not donee_conns.include?(other_conn)
    new_donee_conns = donee_conns - [existing_donee_conn] + [other_conn] # change "Bart -> Maggie" as donees

    expected_notified_users = wish.donor_users + wish.donee_users + [other_conn.friend] - [updating_user] # all donors + Bart + Maggie

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(donee_conn_ids: new_donee_conns.collect(&:id)), updating_user)
    end

    assert service.success?

    self.wish = Wish.find(wish.id)
    assert_changes_only_on(valid_params.slice(:title, :description).merge({ donee_conns: [author_conn] + new_donee_conns,
                                                                            donor_conns: donor_conns - [connections(:bart_to_homer), bart_to_milhouse_conn], # also no Milhouse
                                                                            updated_by_donee_at: Time.current }))
    assert_not_includes wish.donor_users, users(:milhouse)

    assert_notified(users: wish.donor_users, key: 'wish.notifications.updated', notifier: updating_user, notifiable: wish)
    assert_notified(users: wish.donee_users - [updating_user], key: 'wish.notifications.updated', notifier: updating_user, notifiable: wish)
    assert_notified(users: [users(:milhouse)], key: 'wish.notifications.removed_you_as_donor', notifier: updating_user, notifiable: wish) # Homer is still between donors, from Lisa side
    assert_notified(users: [users(:bart)], key: 'wish.notifications.removed_you_as_donee', notifier: updating_user, notifiable: wish)
  end

  test 'author can mark wish as fulfilled' do
    self.updating_user = wish.author

    action = :fulfilled
    assert wish.available_actions_for(updating_user).include?(action)

    expected_notified_users = wish.donor_users + wish.donee_users - [updating_user]

    self.original_attributes = wish.attributes.dup.symbolize_keys

    service = assert_difference('ActivityNotification::Notification.count', expected_notified_users.size ) do
      WishUpdater.call(wish, valid_params.merge(state_action: action.to_s), updating_user)
    end

    assert service.success?
    assert_equal I18n.t('wishes.actions.fulfilled.message', wish_title: wish.title, user_name: updating_user.name), service.result.message

    self.wish = Wish.find(wish.id)
    assert_changes_only_on({ state: Wish::State::STATE_FULFILLED, updated_by_donee_at: Time.current })

    assert_notified(users: expected_notified_users, key: 'wish.notifications.fulfilled', notifier: updating_user, notifiable: wish)
  end

  test 'fails on author update' do
    self.updating_user = wish.author

    new_title = "a" # not empty, but too short
    wish_params = valid_params
    wish_params[:title] = new_title

    service = assert_no_difference('ActivityNotification::Notification.count') do
      WishUpdater.call(wish, wish_params, updating_user)
    end

    assert service.failed?
    assert_equal ["Error on creating wish, see wish.errors"], service.errors

    updated_not_saved_wish = service.result.wish
    persisted_wish = Wish.find(wish.id)
    assert_equal new_title, updated_not_saved_wish.title
    assert_not_equal new_title, persisted_wish.title

    assert_equal ["Tenhle Titulek je minimální až moc"], updated_not_saved_wish.errors[:title]

    assert_equal wish_params[:description], updated_not_saved_wish.description
    assert_equal donor_conns.sort, updated_not_saved_wish.donor_connections.sort
    assert_equal (donee_conns + [wish.author.base_connection]).sort, updated_not_saved_wish.donee_connections.sort
    assert_equal updating_user, updated_not_saved_wish.author
    assert_equal updating_user, updated_not_saved_wish.updated_by
  end

  def assert_notified(users:, key:, notifier:, notifiable:)
    users.each do |target|
      assert target.notifications.where(notifiable: notifiable, notifier: notifier).filtered_by_key(key).exists?,
              "Notification for #{target.email} for '#{key}' not found between #{target.notifications.all.to_a}"
    end
  end

  def assert_changes_only_on(changes)
    assert wish.persisted?
    assert_equal updating_user, wish.updated_by

    original_attributes.except(:updated_at, :created_at, :updated_by_id).each_pair do |att, value|
      expected_value = changes.has_key?(att) ? changes[att] : value
      current_value =  wish.attributes[att.to_s]

      if expected_value.nil?
        assert_nil current_value, "attribute :#{att} is #{current_value} instead expected NIL"
      elsif expected_value.respond_to?(:utc) # time
        assert (current_value.before?(expected_value) || current_value.eql?(expected_value)), "attribute :#{att} is #{current_value} instead expected #{expected_value}"
      else
        assert_equal expected_value, current_value, "attribute :#{att} is #{current_value} instead expected #{expected_value}"
      end
    end

    expected_donor_conns = (changes[:donor_conns] || donor_conns).sort
    assert_equal expected_donor_conns, wish.donor_connections.sort, "DONORS connections should be \n#{expected_donor_conns} but got\n#{wish.donor_connections.sort}"
    expected_donee_conns = (changes[:donee_conns] || (donee_conns + [author_conn])).sort
    assert_equal expected_donee_conns, wish.donee_connections.sort, "DONEES connections should be \n#{expected_donee_conns} but got\n#{wish.donee_connections.sort}"
  end
end
