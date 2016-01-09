class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
         #, :omniauth_providers => [:google_oauth2]
  has_many :identities, class_name: 'User::Identity', dependent: :destroy



  def displayed_name
    name || email
  end       

  #https://www.digitalocean.com/community/tutorials/how-to-configure-devise-and-omniauth-for-your-rails-application
  #inspired from http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  def self.find_or_create_from_omniauth!(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = User::Identity.find_for_auth(auth)
    identity = User::Identity.create_from_auth!(auth) unless identity.present?

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
          password: Devise.friendly_token[0,20]
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



end
