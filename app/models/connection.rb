# frozen_string_literal: true

# == Schema Information
#
# Table name: connections
#
#  id        :integer          not null, primary key
#  email     :string           not null
#  name      :string           not null
#  friend_id :integer
#  owner_id  :integer
#
# Connection between User and somebody, based on email. It have it's own name.
# So different user can have connection to same email address, but each one can name it differently (eg.: Husband, Dad, Son)
# It can be connected to existing other user (known as Friend).
# Or it can just point to nobody waiting for new user with that email address between it's identyties
class Connection < ApplicationRecord
  BASE_CONNECTION_NAME = '--base for donee--'

  belongs_to :friend, class_name: 'User', inverse_of: :connections_as_friend
  belongs_to :owner, class_name: 'User', inverse_of: :connections

  has_many :identities, primary_key: 'email', foreign_key: 'email', class_name: 'User::Identity' # , inverse_of: :connections
  has_and_belongs_to_many :groups

  has_many :donor_links, dependent: :destroy, inverse_of: :connection
  has_many :donor_wishes, through: :donor_links, source: :wish
  has_many :donee_links, dependent: :destroy, inverse_of: :connection
  has_many :donee_wishes, through: :donee_links, source: :wish

  # If you want to be sure that an association is present,
  # you'll need to test whether the associated object itself is present,
  # and not the foreign key used to map the association.
  validates :owner, presence: true
  validates :friend, presence: true, allow_nil: true

  validates :email, presence: true, format: { with: User::Identity::EMAIL_REGEXP }
  validates :name, presence: true, format: { with: /\A\S.+\S\z/ } # minimum 3 charakters, first and last is non-whitespace
  validates :name, format: { without: Regexp.new(BASE_CONNECTION_NAME) }, unless: proc { |conn| conn.owner_id == conn.friend_id }

  before_validation :assign_friend

  def email=(email)
    self[:email] = email.is_a?(String) ? email.downcase : email
  end

  def available_actions_for(user)
    user.id == owner_id ? %i[show edit delete] : []
  end

  def displayed_name
    fullname
  end

  def fullname
    "#{conn_name} [#{friend_uname}]: #{email}"
  end

  def conn_name
    base? ? I18n.t('connections.base_cover_name') : name
  end

  def friend_uname
    return owner.displayed_name if base?
    return '???' if friend_id.blank? # friend (as registered user) was not assigned  unless fre
    return I18n.t('connections.friend_deleted') if friend.blank?

    friend.displayed_name
  end

  def base?
    name == BASE_CONNECTION_NAME
  end

  # sorting method
  def <=>(other)
    s_by_name = (name <=> other.name)
    if s_by_name.zero?
      email <=> other.email
    else
      s_by_name
    end
  end

  scope :base, -> { where(name: BASE_CONNECTION_NAME) }
  scope :friends, -> { where.not(name: Connection::BASE_CONNECTION_NAME) }
  scope :owned_by, ->(user) { where(owner_id: user.id) }

  private

  def assign_friend
    if friend.blank?
      self.friend = identities.first.user if identities.present?
    elsif identities.blank?
      self.friend = nil
    end
  end
end
