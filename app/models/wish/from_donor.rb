#donor can change state of wish only
class Wish::FromDonor < Wish
	self.table_name='wishes'


  def destroy(by_user=nil)
  	#no destroy for Donor
  	return false
  end	
end
