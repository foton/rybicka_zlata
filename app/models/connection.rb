# frozen_string_literal: true

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
  def <=>(conn2)
    s_by_name = (name <=> conn2.name)
    if s_by_name == 0
      email <=> conn2.email
    else
      s_by_name
    end
  end

  scope :base, -> { where(name: BASE_CONNECTION_NAME) }
  scope :friends, -> { where('name <> ?', Connection::BASE_CONNECTION_NAME) }
  scope :owned_by, ->(user) { where(owner_id: user.id) }

  private

  def assign_friend
    self.friend = identities.first.user if identities.present?
  end
end
