# frozen_string_literal: true

# == Schema Information
#
# Table name: wishes
#
#  id                         :integer          not null, primary key
#  description                :text
#  state                      :integer          default(0), not null
#  title                      :string           not null
#  updated_by_donee_at        :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  author_id                  :integer          not null
#  booked_by_id               :integer
#  called_for_co_donors_by_id :integer
#  updated_by_id              :bigint
#
require 'url_regexp'

class Wish < ApplicationRecord
  SHORT_DESCRIPTION_LENGTH = 200

  attr_writer :ex_donee_users, :ex_donor_users, :new_donee_users, :new_donor_users

  include Wish::State

  belongs_to :author, class_name: 'User'
  belongs_to :booked_by_user, class_name: 'User', foreign_key: 'booked_by_id'
  belongs_to :called_for_co_donors_by_user, class_name: 'User', foreign_key: 'called_for_co_donors_by_id'
  belongs_to :updated_by, class_name: 'User'

  has_many :donor_links, dependent: :delete_all, inverse_of: :wish
  has_many :donor_connections, through: :donor_links, source: :connection
  has_many :donee_links, dependent: :delete_all, inverse_of: :wish
  has_many :donee_connections, through: :donee_links, source: :connection

  has_many :posts, class_name: 'Discussion::Post', dependent: :delete_all, inverse_of: :wish

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :author, presence: true
  validate :no_same_donor_and_donee
  validate :validate_booked_by
  validate :validate_called_for_co_donors

  before_validation :ensure_good_styling_of_description

  after_initialize do
    @donors_changed = false
    @donees_changed = false
  end

  after_save do
    @donors_changed = false
    @donees_changed = false
  end


  acts_as_notifiable :donors, { targets: ->(wish, _key) { wish.donor_users - [wish.updated_by] - wish.new_donor_users } }

  acts_as_notifiable :donees, { targets: ->(wish, _key) { wish.donee_users - [wish.updated_by] - wish.new_donee_users }
    # does not work, beacasue gem is looking for [:users][:notifiable_path] in options, but have stored [:donees][:notifiable_path]
    # notifiable_path: :wish_notifiable_path
    # so we used fall back to polymorphics path `wishes/:id` and handle it there
  }

  acts_as_notifiable :ex_donees, { targets: ->(wish, _key) { wish.ex_donee_users }}
  acts_as_notifiable :ex_donors, { targets: ->(wish, _key) { wish.ex_donor_users }}
  acts_as_notifiable :new_donees, { targets: ->(wish, _key) { wish.new_donee_users }}
  acts_as_notifiable :new_donors, { targets: ->(wish, _key) { wish.new_donor_users }}

  scope :not_fulfilled, -> { where.not(state: Wish::State::STATE_FULFILLED) }
  scope :fulfilled, -> { where(state: Wish::State::STATE_FULFILLED) }

  def available_donor_connections_from(connections)
    emails_of_donees = donee_connections.collect(&:email).uniq.compact
    user_ids_of_donees = donee_connections.collect(&:friend_id).uniq.compact

    # (connections-connections.where(email: emails_of_donees)-connections.where(friend_id: user_ids_of_donees))
    (connections.reject { |conn| (emails_of_donees.include?(conn.email) || user_ids_of_donees.include?(conn.friend_id)) })
  end

  def available_user_groups_from(user, connections)
    only_whole_groups_in_collection(user.groups, connections)
  end

  def description_shortened
    if description.to_s.size > SHORT_DESCRIPTION_LENGTH
      dot_dot_dot = ' ...'
      description[0..(SHORT_DESCRIPTION_LENGTH - dot_dot_dot.length)].gsub(/ \S*\z/, '') + dot_dot_dot
    else
      description
    end
  end

  def author?(user)
    author == user
  end

  def donor?(user)
    donor_users.include?(user)
  end

  def donee?(user)
    donee_users.include?(user)
  end

  def donor_users
    @donor_users ||= User.find(donor_user_ids)
  end

  def donee_users
    @donee_users ||= User.find(donee_user_ids)
  end

  def ex_donee_users
    @ex_donee_users ||= []
  end

  def ex_donor_users
    @ex_donor_users ||= []
  end

  def new_donee_users
    @new_donee_users ||= []
  end

  def new_donor_users
    @new_donor_users ||= []
  end

  def donee_user_ids
    @donee_user_ids ||= donee_connections.collect(&:friend_id).uniq.compact
  end

  def donor_groups_for(user)
    only_whole_groups_in_collection(user.groups, donor_connections)
  end

  def donee_groups_for(user)
    only_whole_groups_in_collection(user.groups, donee_connections)
  end

  def shared?
    (@donee_user_ids || donee_links).count > 1
  end

  def changed?
    super || @donors_changed || @donees_changed
  end

  def donors_changed?
    @donors_changed
  end

  def donees_changed?
    @donees_changed
  end

  def donee_conn_ids
    @donee_conn_ids ||= donee_connections.collect(&:id)
  end

  def donor_conn_ids
    @donor_conn_ids ||= donor_connections.collect(&:id)
  end

  def <=>(other)
    id <=> other.id
  end

  def to_plain_wish
    Wish.find(id)
  end

  def wish_title
    title
  end


  private

  def donor_user_ids
    @donor_user_ids ||= donor_connections.collect(&:friend_id).uniq.compact
  end

  def only_whole_groups_in_collection(groups, collection)
    whole_groups = []
    groups.each do |grp|
      whole_groups << grp if whole_group_in_collection?(grp, collection)
    end
    whole_groups
  end

  def whole_group_in_collection?(group, conn_collection)
    wish_conn_emails = if conn_collection.is_a?(Array)
                         conn_collection.to_a.collect(&:id)
                       else # probably AR Relation
                         conn_collection.pluck(:email)
                       end
    grp_conn_emails = group.connections.pluck(:email)

    (grp_conn_emails == (grp_conn_emails & wish_conn_emails))
  end

  # wish should not have the same USER or CONNECTION.EMAIL as donee and donor
  def no_same_donor_and_donee
    donor_conns = donor_connections.to_a
    donee_conns = donee_connections.to_a

    # first check for same connection
    in_both = donor_conns & donee_conns
    if in_both.present?
      add_same_donor_and_donee_error(I18n.t('wishes.errors.same_donor_and_donee.by_connection', conn_fullname: in_both.first.fullname))
    else
      # check for connection with same email (cann be dubled with another name)
      donor_emails = donor_conns.collect(&:email)
      donee_emails = donee_conns.collect(&:email)
      in_both = donor_emails & donee_emails
      if in_both.present?
        add_same_donor_and_donee_error(I18n.t('wishes.errors.same_donor_and_donee.by_email', email: in_both.first))
      else
        # check for identical user directly (can have many emails)
        donor_user_ids = donor_conns.collect(&:friend_id).compact
        donee_user_ids = donee_conns.collect(&:friend_id).compact
        in_both = donor_user_ids & donee_user_ids
        if in_both.present?
          donor_connection = (donor_conns.select { |c| c.friend_id == in_both.first }).first
          donee_connection = (donee_conns.select { |c| c.friend_id == in_both.first }).first
          add_same_donor_and_donee_error(I18n.t('wishes.errors.same_donor_and_donee.by_user', donee_fullname: donee_connection.fullname, donor_fullname: donor_connection.fullname))
        end
      end
    end
  end

  def add_same_donor_and_donee_error(text)
    errors.add(:donor_conn_ids, text)
    errors.add(:donee_conn_ids, text)
  end

  def ensure_good_styling_of_description
    # add space after comma, unless it is in URL
    return if description.blank?

    description.gsub!(/([^\s]+),([^\s]+)/) do
      m = Regexp.last_match
      m[0].match(::Regexp::PERFECT_URL_PATTERN) ? m[0] : "#{m[1]}, #{m[2]}"
    end
  end

  def validate_booked_by
    if [STATE_RESERVED, STATE_GIFTED].include?(state)
      if booked_by_user.blank?
        errors.add(:booked_by_id, I18n.t('wishes.errors.must_have_booking_user'))
      elsif donee?(booked_by_user)
        errors.add(:booked_by_id, I18n.t('wishes.errors.cannot_be_booked_by_donee'))
      end
    elsif STATE_AVAILABLE == state
      if booked_by_user.present?
        errors.add(:booked_by_id, I18n.t('wishes.errors.cannot_be_booked_in_this_state'))
      end
    end
  end

  def validate_called_for_co_donors
    if [STATE_CALL_FOR_CO_DONORS].include?(state)
      if called_for_co_donors_by_user.blank?
        errors.add(:called_for_co_donors_by_id, I18n.t('wishes.errors.must_have_calling_by_user'))
      elsif donee?(called_for_co_donors_by_user)
        errors.add(:called_for_co_donors_by_id, I18n.t('wishes.errors.donee_cannot_call_for_co_donors'))
      end
    elsif STATE_AVAILABLE == state
      if called_for_co_donors_by_user.present?
        errors.add(:called_for_co_donors_by_id, I18n.t('wishes.errors.cannot_be_called_in_this_state'))
      end
    end
  end

  def monitored_changes
    saved_changes.slice(*monitored_attributes)
  end

  def monitored_attributes
    %w[title description state] # booked_by_id, called_for_co_donors_by_id
  end
end
