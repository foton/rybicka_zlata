# frozen_string_literal: true

class WishUpdater
  attr_accessor :errors, :result, :wish, :updating_user, :update_params

  WU_Struct = Struct.new(:wish, :message)

  def self.call(wish, update_params, updating_user)
    srv = new(wish, update_params, updating_user)
    srv.call
    srv
  end

  def initialize(wish, update_params, updating_user)
    @wish = get_correct_wish_instance(wish, updating_user)
    @update_params = update_params.symbolize_keys
    @updating_user = updating_user
  end

  def call
    @errors = []
    @result = WU_Struct.new(update_wish, message)
  end

  def success?
    errors.blank?
  end

  def failed?
    !success?
  end

  private

  attr_reader :wish
  attr_accessor :notifications, :message

  def update_wish
    setup

    donor_allowed_update if wish.donor?(updating_user)
    donee_allowed_update if wish.donee?(updating_user)
    author_allowed_updates if wish.author?(updating_user)

    errors << wish.errors if wish.errors.present?

    if notifications.values.flatten.present?
      wish.updated_by = updating_user
    end # something important happened

    if wish.save
      wish.reload # to get changes in donors and donees
      notify_users
    else
      errors << 'Error on creating wish, see wish.errors'
    end

    wish
  end

  def setup
    @notifications = { donors: [],
                       donees: [],
                       ex_donees: [],
                       ex_donors: [],
                       new_donors: [],
                       new_donees: [] }

    wish.ex_donee_users = []
    wish.ex_donor_users = []
    wish.new_donee_users = []
    wish.new_donor_users = []
  end

  def donor_allowed_update
    action = modified_params[:state_action].to_sym
    return unless wish.available_actions_for(updating_user).include?(action)

    self.message = wish.send("#{action}!", updating_user)
    notifications[:donors] << "wish.#{action}"
  end

  def donee_allowed_update
    if action = modified_params[:state_action]&.to_sym
      return unless  wish.available_actions_for(updating_user).include?(action)

      self.message = wish.send("#{action}!", updating_user)
      notifications[:donors] << "wish.#{action}"
      notifications[:donees] << "wish.#{action}"
    else
      change_donors!(modified_params[:donor_conn_ids])
    end
  end

  def author_allowed_updates
    if modified_params[:state_action]&.to_sym
      return
    end # update by ACTION (handled in donee) or by ATTRIBUTES

    # attribute update. Only some attributes can be updated
    %i[title description].each do |att|
      next if modified_params[att].blank?

      wish.write_attribute(att, modified_params[att])
      if wish.changes.keys.include?(att.to_s)
        notifications[:donors] << 'wish.updated'
        notifications[:donees] << 'wish.updated'
      end
    end

    change_donees!(modified_params[:donee_conn_ids])
  end

  def notify_users
    notifications.each_pair do |notify_group, keys|
      keys.uniq.each { |key| wish.notify(notify_group, key: key, notifier: updating_user) }
    end
  end

  def modified_params
    @modified_params ||= update_params.except(:user_id)
  end

  def get_correct_wish_instance(wish, updating_user)
    return Wish::FromAuthor.find(wish.id) if wish.author?(updating_user)
    return Wish::FromDonee.find(wish.id) if wish.donee?(updating_user)
    return Wish::FromDonor.find(wish.id) if wish.donor?(updating_user)

    wish
  end

  def change_donors!(conn_ids)
    return if conn_ids.blank?

    previous_donors = wish.donor_users

    wish.merge_donor_conn_ids(conn_ids, updating_user)

    removed_donors = previous_donors - wish.donor_users
    new_donors = wish.donor_users - previous_donors

    return unless wish.donors_changed?

    notifications[:donors] << 'wish.updated'
    notifications[:donees] << 'wish.updated'
    wish.ex_donor_users += removed_donors
    wish.new_donor_users += new_donors
    notifications[:ex_donors] << 'wish.removed_you_as_donor'
    notifications[:new_donors] << 'wish.added_you_as_donor'
  end

  def change_donees!(conn_ids)
    return if conn_ids.blank?

    previous_donees = wish.donee_users
    wish.donee_conn_ids = conn_ids
    removed_donees = previous_donees - wish.donee_users
    new_donees = wish.donee_users - previous_donees

    completely_remove(removed_donees)

    return unless wish.donees_changed?

    wish.new_donee_users += new_donees
    notifications[:new_donees] << 'wish.added_you_as_donee'
    notifications[:donors] << 'wish.updated'
    notifications[:donees] << 'wish.updated'
  end

  def completely_remove(removed_donees)
    wish.ex_donee_users = removed_donees

    removed_donees.each do |ex_donee|
      ex_conns = wish.donor_connections.select { |dc| dc.owner_id == ex_donee.id }
      wish.ex_donor_users += ex_conns.collect { |dc| dc.friend }
      wish.merge_donor_conn_ids([], ex_donee)
    end

    # same donor user can be linked from other donee
    new_donor_users = wish.donor_links.includes(connection: [:friend]).collect do |link|
      link.connection.friend
    end
    wish.ex_donor_users -= new_donor_users

    notifications[:ex_donees] << 'wish.removed_you_as_donee'
    notifications[:ex_donors] << 'wish.removed_you_as_donor'
  end
end
