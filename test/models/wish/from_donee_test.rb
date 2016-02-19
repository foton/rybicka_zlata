require 'test_helper'

class WishFromDoneeTest < ActiveSupport::TestCase

	def setup
		@author=create_test_user!
    @donee=create_test_user!(name: "Donee Brasco", email: "donee@home.cz")
		assert @author.base_connection.valid?
     
    @conn1= Connection.create!(name: "Simon", email: "simon@says.com", owner_id: @author.id)
    @conn2= Connection.create!(name: "Paul", email: "Paul.Simon@says.com", owner_id: @author.id)
    @conn_donee= Connection.create!(name: "Donee", email: @donee.email, owner_id: @author.id)

    a_wish=Wish::FromAuthor.new(
			author: @author, 
			title: "My first wish", 
			description: "This is my first wish I am trying", 
			donee_conn_ids: [] 
			)
    a_wish.merge_donor_conn_ids [@conn1.id, @conn2.id], @author
    a_wish.save!
    
    a_shared_wish=Wish::FromAuthor.new(
      author: @author, 
      title: "My first shared wish", 
      description: "This is my first shared", 
      donee_conn_ids: [@conn_donee.id] 
      )
    a_shared_wish.merge_donor_conn_ids([@conn1.id, @conn2.id], @author)
    a_shared_wish.save!

    @wish=Wish::FromDonee.find(a_wish.id)
    @shared_wish=Wish::FromDonee.find(a_shared_wish.id)
	end	

	def test_cannot_update_wish_without_title
		@shared_wish.title=""
		refute @shared_wish.valid?
		assert_equal ["je povinná položka"],@shared_wish.errors[:title]
	end	

	def test_cannot_update_wish_without_author
		@shared_wish.author=nil
		refute @shared_wish.valid?
		assert_equal ["je povinná položka"],@shared_wish.errors[:author]
	end	

  def test_can_update_wish_without_description
		@shared_wish.description=""
		assert @shared_wish.valid?
	end	

  def test_add_donors_connections_and_remove_only_them
  	conn_jpb= Connection.create!(name: "Jean Paul", email: "belmondo@paris.fr", owner_id: @donee.id)
    conn_jr= Connection.create!(name: "Jean Reno", email: "reno@paris.fr", owner_id: @donee.id)
    
    @shared_wish.merge_donor_conn_ids([conn_jpb.id],@donee)
  	assert @shared_wish.save
  	@shared_wish.reload

    assert_equal [@conn1, @conn2, conn_jpb].sort, @shared_wish.donor_connections.sort
  
    @shared_wish.merge_donor_conn_ids([@conn2.id, conn_jr.id],@donee)
    assert @shared_wish.save
    @shared_wish.reload

    #@conn1 is not removed, just conn_jpb
    assert_equal [@conn1, @conn2, conn_jr].sort, @shared_wish.donor_connections.sort
  end  

  def test_can_remove_yourself_from_donees_by_call_for_destroy
    assert @donee.donee_wishes.include?(@shared_wish)
    
    @shared_wish.destroy(@donee)
    
    refute @donee.donee_wishes.include?(@shared_wish)
    assert @author.donee_wishes.include?(@shared_wish)
  end
    
  def test_cannot_change_donees_connections
    assert_equal [@author.base_connection,@conn_donee].sort, @shared_wish.donee_connections.sort

  	conn_jpb= Connection.create!(name: "Jan Paul", email: "belmondo@paris.fr", owner_id: @donee.id)
  	@shared_wish.donee_conn_ids=[conn_jpb.id]
  	assert @shared_wish.save #just silently ignoring attempt to add donees
  	@shared_wish.reload

    assert_equal [@author.base_connection,@conn_donee].sort, @shared_wish.donee_connections.sort
  end	

  def test_set_updated_by_donee_at
  	assert @shared_wish.save
  	updated_by_donee=@shared_wish.updated_by_donee_at
  	sleep 1.second
  	@shared_wish.title="new title"
  	assert @shared_wish.save
  	assert ((updated_by_donee+1.second) < @shared_wish.updated_by_donee_at)
  end	
end