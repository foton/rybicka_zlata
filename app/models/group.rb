class Group < ActiveRecord::Base
	belongs_to :user
  has_and_belongs_to_many :connections

  validates :name, presence: true
  #If you want to be sure that an association is present,
  #you'll need to test whether the associated object itself is present, 
  #and not the foreign key used to map the association.
  validates :user, presence: true



  def available_actions_for(user)
    user.id == self.user_id ? [:show, :edit, :delete] : []
  end  

  def displayed_name
    name
  end  
end
