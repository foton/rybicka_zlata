require 'test_helper'

class WishFromDoneeTest < ActiveSupport::TestCase

  Donor=Struct.new(:id, :name, :email) #usbstituting Connection Record

	def setup
		@author=create_test_user!
		assert @author.base_connection.valid?
     
    @wish=Wish::FromDonee.new(
			author: @author, 
			title: "My first wish", 
			description: "This is my first wish I am trying", 
			donor_conn_ids: [],
			donee_conn_ids: [] 
			)
	end	


	def test_can_create_wish
		assert @wish.valid?
	end	

	def test_cannot_create_wish_without_title
		@wish.title=""
		refute @wish.valid?
		assert_equal ["je povinná položka"],@wish.errors[:title]
	end	

	def test_cannot_create_wish_without_author
		@wish.author=nil
		refute @wish.valid?
		assert_equal ["je povinná položka"],@wish.errors[:author]
	end	

  def test_can_create_wish_without_description
		@wish.description=""
		assert @wish.valid?
	end	

  def test_can_create_wish_without_donors
		@wish.donor_conn_ids=[]
		assert @wish.valid?
	end	

  def test_can_create_wish_without_donees
		@wish.donee_conn_ids=[]
		assert @wish.valid?
	end	

  def test_add_donors_connections
  	conn1= Connection.create!(name: "Simon", email: "simon@says.com", owner_id: @author.id)
  	conn2= Connection.create!(name: "Paul", email: "Paul.Simon@says.com", owner_id: @author.id)
  	@wish.donor_conn_ids=([conn1,conn2].collect {|c| c.id})
  	
  	assert @wish.save
  	@wish.reload
    assert_equal [conn1,conn2].sort, @wish.donor_connections.sort
  end	

  def test_add_donees_connections
  	conn1= Connection.create!(name: "Simon", email: "simon@says.com", owner_id: @author.id)
  	conn2= Connection.create!(name: "Paul", email: "Paul.Simon@says.com", owner_id: @author.id)
  	@wish.donee_conn_ids=([conn1,conn2].collect {|c| c.id})
  	
  	assert @wish.save
  	@wish.reload
    assert_equal [conn1,conn2,@author.base_connection].sort, @wish.donee_connections.sort
  end	

  def test_set_updated_by_donee_at
  	assert @wish.save
  	updated_by_donee=@wish.updated_by_donee_at
  	sleep 1.second
  	@wish.title="new title"
  	assert @wish.save
  	assert ((updated_by_donee+1.second) < @wish.updated_by_donee_at)
  end	

end