class Connection < ActiveRecord::Base
	BASE_CONNECTION_NAME="--base for donee--"

  belongs_to :friend, class_name: User, inverse_of: :connections_as_friend
	belongs_to :owner, class_name: User, inverse_of: :connections

  has_many :identities, primary_key: 'email', foreign_key: 'email', class_name: 'User::Identity'#, inverse_of: :connections
  has_and_belongs_to_many :groups

  has_many :donor_links, dependent: :destroy, inverse_of: :connection
  has_many :donor_wishes, through: :donor_links, source: :wish
  has_many :donee_links, dependent: :destroy, inverse_of: :connection
  has_many :donee_wishes, through: :donee_links, source: :wish

  #If you want to be sure that an association is present,
  #you'll need to test whether the associated object itself is present, 
  #and not the foreign key used to map the association.
  validates :owner, presence: true
  validates :friend, presence: true, allow_nil: true

  validates :email, presence: true, format: { with: User::Identity::EMAIL_REGEXP} 
  validates :name, presence: true, format: { with: /\A\S.+\S\z/ } #minimum 3 charakters, first and last is non-whitespace
  validates :name, format: { without: Regexp.new(BASE_CONNECTION_NAME)}, unless: Proc.new {|conn| conn.owner_id == conn.friend_id }

  
  before_validation :assign_friend

  

  def fullname
    conn_name=name
    friend_uname="???" #friend (as registered user) was not assigned
    if base?
      conn_name=I18n.t("connection.base_cover_name")
      friend_uname=owner.displayed_name
    else
      if friend_id.present? 
        if friend.blank?
          #friend (as registered user) was assigned, but now it does not exists (deleted)
          friend_uname=I18n.t("connection.friend_deleted")
        else
          #friend (as registered user) is assigned
          friend_uname=friend.displayed_name
        end  
      end
    end  
    "#{conn_name} [#{friend_uname}]: #{email}"
  end  

  def base?
    name == BASE_CONNECTION_NAME
  end  

  #sorting method
  def  <=>(conn2)
    s_by_name= (self.name <=> conn2.name)
    if s_by_name == 0
      self.email <=> conn2.email
    else
      s_by_name  
    end  
  end  

  scope :base, -> { where(name: BASE_CONNECTION_NAME) }
  scope :friends, -> {where("name <> ?", Connection::BASE_CONNECTION_NAME) }
  scope :owned_by, -> (user) { where(owner_id: user.id) }

  private

    def assign_friend
    	if identities.present?
    		self.friend = identities.first.user
    	end	
    end	


end
