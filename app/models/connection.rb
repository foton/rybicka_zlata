class Connection < ActiveRecord::Base
	belongs_to :friend, class_name: User 
	belongs_to :owner, class_name: User

  has_many :identities, primary_key: 'email', foreign_key: 'email', class_name: 'User::Identity'
  has_and_belongs_to_many :groups

  validates :email, presence: true, format: { with: User::Identity::EMAIL_REGEXP} 
  validates :name, presence: true, format: { with: /\A\S.+\S\z/ } #minimum 3 charakters, first and last is non-whitespace
  #If you want to be sure that an association is present,
  #you'll need to test whether the associated object itself is present, 
  #and not the foreign key used to map the association.
  validates :owner, presence: true
  validates :friend, presence: true, allow_nil: true
  
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

  private

    def assign_friend
    	if identities.present?
    		self.friend = identities.first.user
    	end	
    end	


end