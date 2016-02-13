class Connection < ActiveRecord::Base
	BASE_CONNECTION_NAME="--base for donee--"

  belongs_to :friend, class_name: User 
	belongs_to :owner, class_name: User

  has_many :identities, primary_key: 'email', foreign_key: 'email', class_name: 'User::Identity'
  has_and_belongs_to_many :groups

  has_many :donor_links
  has_many :donor_wishes, through: :donor_links, source: :wish
  has_many :donee_links
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
    if friend_id.blank?
      #friend (as registered user) was not assigned
      "#{name} [???]: #{email}"
    elsif friend.blank?
      #friend (as registered user) was assigned, but now it does not exists (deleted)
      "#{name} [deleted]: #{email}"
    else
      #firend (as registered user) is assigned
      "#{name} [#{friend.displayed_name}]: #{email}"
    end  
  end  

  scope :base, -> { where(name: BASE_CONNECTION_NAME) }
  scope :friends, -> {where("name <> ?", Connection::BASE_CONNECTION_NAME) }

  private

    def assign_friend
    	if identities.present?
    		self.friend = identities.first.user
    	end	
    end	


end