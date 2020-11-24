# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  body_height                :string           default("??")
#  body_weight                :string           default("??")
#  confirmation_sent_at       :datetime
#  confirmation_token         :string
#  confirmed_at               :datetime
#  current_sign_in_at         :datetime
#  current_sign_in_ip         :inet
#  dislikes                   :text             default(":-(")
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  last_sign_in_at            :datetime
#  last_sign_in_ip            :inet
#  likes                      :text             default(":-)")
#  locale                     :string(5)        default("cs"), not null
#  name                       :string
#  other_sizes_and_dimensions :text             default("")
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  shoes_size                 :string           default("EU/UK/US??")
#  sign_in_count              :integer          default(0), not null
#  time_zone                  :string           default("Prague"), not null
#  trousers_leg_size          :string           default("??")
#  trousers_waist_size        :string           default("??")
#  tshirt_size                :string           default("??")
#  unconfirmed_email          :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/.freeze
  BASE_CONNECTION_NAME = '--base--'
  ADMIN_EMAIL = 'porybny@rybickazlata.cz'

  acts_as_target # for notifications

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  # , :omniauth_providers => [:google_oauth2]
  has_many :identities, -> { order('email ASC') }, class_name: 'User::Identity', dependent: :destroy, inverse_of: :user
  has_many :connections, -> { order('name ASC, email ASC') }, foreign_key: 'owner_id', dependent: :destroy, inverse_of: :owner
  has_many :friend_connections, -> { where.not(name: Connection::BASE_CONNECTION_NAME).order('name ASC') }, class_name: 'Connection', foreign_key: 'owner_id'
  has_many :friends, through: :friend_connections, source: :friend
  has_many :connections_as_friend, -> { order('name ASC, email ASC') }, class_name: 'Connection', foreign_key: 'friend_id'
  has_many :groups, -> { order('name ASC') }, dependent: :destroy, inverse_of: :user

  # wishes where user is author
  has_many :author_wishes, -> { order('updated_at DESC') }, class_name: 'Wish::FromAuthor', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author

  # has_many :friends, -> { order("name ASC") }, class_name: 'User'
  # has_many :registered_connections, -> { order("name ASC") }, class_name: 'Connection', dependent: :destroy

  after_save :ensure_main_identity
  after_save :ensure_base_connection

  def displayed_name
    name || email
  end

  # without connection, user.displayed_name is used
  # with connection watchman-> user , connection.name is used
  def displayed_name_for(watchman)
    conns = watchman.friend_connections.where(friend: self)
    conns.present? ? conns.first.name : displayed_name
  end

  def anchor
    email.parameterize
  end

  def self.admin
    User.find_by(email: ADMIN_EMAIL)
  end

  def admin?
    (email == ADMIN_EMAIL)
  end

  # https://www.digitalocean.com/community/tutorials/how-to-configure-devise-and-omniauth-for-your-rails-application
  # inspired from http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  def self.find_or_create_from_omniauth!(auth, signed_in_resource = nil)
    password = nil
    # Get the identity and user if they exist
    identity = User::Identity.find_for_auth(auth)
    identity = User::Identity.create_from_auth(auth) if identity.blank?

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource || identity.user

    if user.blank?
      email = identity.verified_email
      email = identity.email if email.blank?
      user = User.find_by(email: email) if email
    end

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      password = Devise.friendly_token[0, 20]
      user = User.new(
        name: identity.name,
        # username: auth.info.nickname || auth.uid,
        email: email || identity.temp_email,
        password: password,
        locale: identity.locale || User.new.locale,
        time_zone: identity.time_zone || User.new.time_zone
      )
      user.skip_confirmation!
      raise "User.not saved: #{user.errors.full_messages}  [#{user.to_json}]" unless user.save
    end

    # Associate the identity with the user if needed
    identity.user = user if identity.user != user
    logger.error("Identity before save:#{identity.to_json}")
    identity.save!
    [user, password]
  end

  def base_connection
    connections.base.first
  end

  # wishes where user is between donees
  def donee_wishes
    dls = DoneeLink.where(connection_id: connections_as_friend.collect(&:id))
    Wish::FromDonee.where(id: dls.collect(&:wish_id).uniq).order('updated_at DESC')
  end

  # wishes where user is between donees
  def donor_wishes
    conns = connections_as_friend - [base_connection]
    dls = DonorLink.where(connection_id: conns.collect(&:id))
    Wish::FromDonor.where(id: dls.collect(&:wish_id).uniq).order('updated_at DESC')
  end

  def author_of?(wish)
    wish.author?(self)
  end

  def donee_of?(wish)
    wish.donee?(self)
  end

  def donor_of?(wish)
    wish.donor?(self)
  end

  def main_identity
    ensure_main_identity
    existing_local_idnts = identities.where(email: email, provider: User::Identity::LOCAL_PROVIDER).order('id ASC')
    return existing_local_idnts.first if existing_local_idnts.present?

    identities.where(email: email).order('id ASC').first
  end

  def printable_target_name
    name
  end
  alias_method :printable_notifier_name, :printable_target_name

  private

  def ensure_main_identity
    existing_idnts = identities.where(email: email)
    if existing_idnts.blank?
      User::Identity.create_for_user!(self)
    else
      idnt = existing_idnts.first
      raise "E-mail #{email} belongs to user #{idnt.user.id}" if idnt.user != self
    end
  end

  def ensure_base_connection
    if base_connection.blank?
      Connection.create!(name: Connection::BASE_CONNECTION_NAME, email: email, friend: self, owner: self)
    end
  end
end
