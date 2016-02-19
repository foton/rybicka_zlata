class User::Identity < ActiveRecord::Base
  belongs_to :user
  has_many :connections, primary_key: 'email', foreign_key: 'email'#, inverse_of: :identities

  self.table_name="identities"

  LOCAL_PROVIDER = "localy_added"
  OAUTH_PROVIDERS=["google", "github", "facebook", "twitter", "linkedin"]
  ALLOWED_PROVIDERS = [LOCAL_PROVIDER, "test"]+OAUTH_PROVIDERS
  EMAIL_REGEXP =/[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?/ # from http://regexlib.com/Search.aspx?k=email&c=1&m=-1&ps=20

  attr_accessor :auth_data

  before_validation :fill_local_uid, on: :create
  after_save :bind_connections_as_friend
  after_destroy :unbind_connections

  validates :provider, presence: true, inclusion: { in: ALLOWED_PROVIDERS}
  validates :uid, presence: true, uniqueness: { scope: :provider, message: "Is already taken for provider" }
  validates :email, presence: true, format: { with: EMAIL_REGEXP},  if: "local?"
  validates :email, format: { with: EMAIL_REGEXP , allow_nil: true}, unless: "local?"
  validate :same_email_same_user
  validates :user, presence: true
  
  def self.find_for_auth(auth)
    i=find_by(uid: auth.uid, provider: auth.provider.to_sym)
    i.auth_data=auth if i
    i
  end

  def self.create_from_auth!(auth, user=nil)
    i=self.create_from_auth(auth,user)
    i.save!
    i
  end

  def self.create_from_auth(auth, user=nil)
    i=self.new(uid: auth.uid, provider: auth.provider.to_sym)
    i.auth_data=auth 
    #if there is verified email, set this one
    i.email=(i.verified_email? ? i.verified_email : auth.info.email)
    i.try_add_user(user)
    i
  end

  def self.create_for_user!(user)
    i=self.new(provider: LOCAL_PROVIDER, user_id: user.id, email: user.email)
    i.save!
  end  

  def self.extractor_for(provider)
    case provider.to_s
      when "google"
        User::Identity::Extractor::Google.new
      when "github"
        User::Identity::Extractor::Github.new
      when "facebook"
        User::Identity::Extractor::Facebook.new
      when "twitter"
        User::Identity::Extractor::Twitter.new
      when "linkedin"
        User::Identity::Extractor::Linkedin.new

      else
        User::Identity::Extractor.new
    end
  end  

  def data
    unless defined? @extractor
      @extractor=self.class.extractor_for(provider)
      @extractor.auth_data=auth_data                                                    
    end                
    @extractor                
  end  

  #TODO: learn and use Delegation to provider
  def name
    @name||=data.name
  end

  def locale
    @locale||=data.locale
  end  

  def time_zone
    @time_zone||=data.time_zone
  end  

  def verified_email
    @verified_email||=data.verified_email
  end  

  def verified_email?
    verified_email.present?
  end  

  def temp_email
    "#{User::TEMP_EMAIL_PREFIX}-#{self.uid}-#{self.provider}.com"
  end  

  def add_user!(user)
    self.user=user 
    self.save!
  end  

  def try_add_user(usr)
    #try to find user if not passed
    if !usr.kind_of?(User) 
      if verified_email.present?
       email_to_search=verified_email 
      else 
       email_to_search=email 
      end
      
      if email.present?
        #this is not needed, because there should be associated Identity with the user.email
        usr=User.find_by_email(email_to_search)

        if usr.blank?
          #try search between identities
          i=User::Identity.where(email: email_to_search).where("id <> ?", self.id)
          usr=i.first.usr if i.present?
        end  
      end  
    end

    self.user=usr if usr.kind_of?(User)
  end

  def local?
    LOCAL_PROVIDER == self.provider.to_s
  end  

  def to_s
    s="#{email}"
    s+=" [#{provider}]" unless local?
    s
  end  
  scope(:local, -> { where( provider: User::Identity::LOCAL_PROVIDER) })
  
  private
  
    def fill_local_uid
      self.uid=User::Identity.local.maximum(:uid).to_i+1 if local?
    end 

    def same_email_same_user
      if self.user_id.present? && User::Identity.where(email: self.email).where(["user_id <> ?",self.user_id]).present?
        self.errors.add(:email, I18n.t("user.identities.email_is_owned_by_another_user", email: self.email)) 
      end  
    end  

    #search if there are unasigned Connections with one of the user mails
    #if they are, make connection
    def bind_connections_as_friend
      connections.where(friend_id: nil).each {|fshp| bind_connection(fshp)}
    end  

    # Identity cannot be updated, just created or deleted
    # def check_connections_to_old_email
    #   if self.previous_changes
    #     old_email="xx"
    #     Connection.where(email: old_email).each {|fshp| unbind_connection(fshp)}
    #   end  
    # end  

    def unbind_connections
      (connections-connections.base).each {|fshp| unbind_connection(fshp)}
    end 

    def bind_connection(fshp)
      fshp.friend=self.user
      fshp.save!
    end 

    def unbind_connection(fshp)
      fshp.friend=nil
      fshp.save!
    end 
end

