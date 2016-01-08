class User::Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  self.table_name="identities"

  attr_accessor :auth_data

  def self.find_for_auth(auth)
    i=find_by(uid: auth.uid, provider: auth.provider)
    i.auth_data=auth if i
    i
  end

  def self.create_from_auth!(auth, user=nil)
    i=self.create(uid: auth.uid, provider: auth.provider, email: auth.email)
    i.auth_data=auth 
    i.try_add_user(user)
    i
  end

  def self.extractor_for(provider)
    case provider.to_sym
      when :google
        User::Identity::Extractor::Google.new
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
    data.name
  end

  def locale
    data.locale
  end  

  def verified_email
    data.verified_email
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
     self.save!
    end 
  end


end
