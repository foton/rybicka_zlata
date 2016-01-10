class User::Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  self.table_name="identities"

  LOCAL_PROVIDER = "localy_added"
  OAUTH_PROVIDERS=["google", "github"]
  ALLOWED_PROVIDERS = [LOCAL_PROVIDER, "test"]+OAUTH_PROVIDERS
  EMAIL_REGEXP =/[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?/ # from http://regexlib.com/Search.aspx?k=email&c=1&m=-1&ps=20

  attr_accessor :auth_data

  before_validation :fill_local_uid
  validates :provider, presence: true, inclusion: { in: ALLOWED_PROVIDERS}
  validates :uid, presence: true, uniqueness: { scope: :provider, message: "Is already taken for provider" }
  validates :email, presence: true, format: { with: EMAIL_REGEXP},  if: "local?"
  validates :email, format: { with: EMAIL_REGEXP , allow_nil: true}, unless: "local?"

  def self.find_for_auth(auth)
    i=find_by(uid: auth.uid, provider: auth.provider.to_sym)
    i.auth_data=auth if i
    i
  end

  def self.create_from_auth!(auth, user=nil)
    i=self.new(uid: auth.uid, provider: auth.provider.to_sym)
    i.auth_data=auth 
    #if there is verified email, set this one
    i.email=(i.verified_email? ? i.verified_email : auth.info.email)
    i.try_add_user(user)
    i.save!
    i
  end

  def self.extractor_for(provider)
    case provider.to_s
      when "google"
        User::Identity::Extractor::Google.new
      when "github"
        User::Identity::Extractor::Github.new
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

  def try_add_user(user)
    if !user.kind_of?(User) && verified_email.present?
      user=User.find_by_email(verified_email)

      if user.blank?
        #try search between identities
        i=User::Identity.where(email: verified_email).where("id <> ?", self.id)
        user=i.first.user if i.present?
      end  
    end  
    if user.kind_of?(User)
     self.user=user 
    end 
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
end
