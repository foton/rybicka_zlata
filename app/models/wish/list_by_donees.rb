class Wish::ListByDonees 
	def initialize(donor, wishes=nil ,include_fulfilled=false)
	  wishes = donor.donor_wishes if wishes.blank?
	  wishes = wishes.not_fulfilled unless include_fulfilled

	  #we need to set wishes to group by donne name
    #one wish can be at many donees (shared wish)
    @wish_list =[]

    # donee_ids=[]
    # wishes.each do |wish|
    #   donee_ids+=wish.donee_user_ids
    # end  
    donee_ids=wishes.inject([]) {|ids,wish| ids+wish.donee_user_ids}
    @donees=User.where(id: donee_ids.compact.uniq ).order("name ASC")
      
    for donee in @donees
    	h={user: donee, wishes: []}
    	#conversion from Wish:FromDonee to Wish::FromDonor needed
    	donee_wishes=Wish::FromDonor.find(donee.donee_wishes.collect {|w| w.id})
      h[:wishes]= wishes.to_a & donee_wishes.to_a
    	@wish_list << h
    end	
	end	

	def donees
		@donees
	end	

	def wishes_for_donee(donee)
    @wish_list.detect {|wsi| wsi[:user] == donee}
  end		

  def all
  	@wish_list
  end	

  def to_a
    @wish_list.collect {|wi| [wi[:user],wi[:wishes]] }
  end  
end
