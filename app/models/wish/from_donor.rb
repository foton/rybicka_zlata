#donor can change state of wish only
class Wish::FromDonor < Wish
	self.table_name='wishes'


  def destroy(by_user=nil)
  	#no destroy for Donor
  	return false
  end	

  #return array of strings (names) of donnes, which are known to user
  # if donee_connection have friend user => displayed_name
  # if donee_connection do not have friend user
  #   if user have between it's connection same email => name from user connection
  #   else donee_connection do not get in array
  def donee_names_for(user)
    @donee_names=[] unless defined? @donee_names
    
    if @donee_names[user.id].nil?
      names=[]
      self.donee_connections.each do |conn|
        if conn.friend
          names << conn.friend.displayed_name
        else
          user_conns_with_email=user.connections.where(email: conn.email)
          if user_conns_with_email.present?
            names << user_conns_with_email.first.name
          end  
        end  
      end  
      @donee_names[user.id] =names.sort
    end    
    @donee_names[user.id]
  end  
end
