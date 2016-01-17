class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
         #, :omniauth_providers => [:google_oauth2]
  has_many :identities, -> { order("email ASC") }, class_name: 'User::Identity', dependent: :destroy
  has_many :friendships, -> { order("name ASC") }, {foreign_key: 'owner_id', dependent: :destroy, inverse_of: :owner}
  
  #has_many :friends, -> { order("name ASC") }, class_name: 'User'
  #has_many :registered_friendships, -> { order("name ASC") }, class_name: 'Friendship', dependent: :destroy

  after_save :sure_identity_from_email

  def displayed_name
    name || email
  end       

  def admin?
    (email == "porybny@rybickazlata.cz")
  end  

  #https://www.digitalocean.com/community/tutorials/how-to-configure-devise-and-omniauth-for-your-rails-application
  #inspired from http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  def self.find_or_create_from_omniauth!(auth, signed_in_resource = nil)
    
    # Get the identity and user if they exist
    identity = User::Identity.find_for_auth(auth)
    identity = User::Identity.create_from_auth(auth) unless identity.present?

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    email=identity.verified_email
    email=identity.email if email.blank?
    user = User.where(:email => email).first if email
    
    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      
      user = User.new(
          name: identity.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : identity.temp_email,
          password: Devise.friendly_token[0,20],
          locale: identity.locale||User.new.locale,
          time_zone: identity.time_zone||User.new.time_zone
        )
      user.skip_confirmation!
      user.save!
      
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  private

    def sure_identity_from_email
      existing_idnts=self.identities.where(email: self.email)
      if existing_idnts.blank?
        User::Identity.create_for_user!(self)        
      else
        idnt=existing_idnts.first
        if idnt.user != self
          raise "E-mail #{self.email} belongs to user #{idnt.user.id}"
        end  
      end  
    end  
end
