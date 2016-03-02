require 'test_helper'

class WishFromDonorTest < ActiveSupport::TestCase

  def setup

    @author=create_test_user!(name: "author")
    @donor=create_test_user!(name: "donor")
    @donee=create_test_user!(name: "donee")


    assert @author != @donor
    assert @author != @donee
    assert @donee != @donor

    @donor_conn=create_connection_for(@author, {name: "donor_conn", email: @donor.email})  
    @donee_conn=create_connection_for(@author, {name: "donee_conn", email: @donee.email})  
    #now connection without users
    @donee2_conn=create_connection_for(@author, {name: "donee2_conn"})  
    @donee3_conn=create_connection_for(@author, {name: "donee3_conn"})  
    
    @wish=Wish::FromAuthor.new(
      author: @author, 
      title: "My first wish", 
      description: "This is my first wish I am trying", 
      donee_conn_ids: [@donee_conn.id,@donee2_conn.id,@donee3_conn.id]
      )
    @wish.merge_donor_conn_ids([@donor_conn.id], @author)
    @wish.save!   
    
    #donor do not have it's own connection to @auhtor, @donee (but they are users)
    #donor do have connection with same email as @donee2_conn
    @donor_to_donee2_conn =create_connection_for(@donor, {name: "donor_to_donee2", email: @donee2_conn.email})
    #donor do not know or have connection with same email as @donee3_conn
    
    @shared_wish=Wish::FromDonor.find(@wish.id)

  end 

  def test_get_right_donee_names
    expected_names=[]
    #donor do not have it's own connection to @auhtor, @donee (but they are users) => use user.displayed_name
    expected_names << @author.displayed_name
    expected_names << @donee.displayed_name

    #donor do have connection with same email as @donee2_conn => use donor name for connection
    expected_names << @donor_to_donee2_conn.name
    expected_names.sort!

    assert_equal expected_names, @shared_wish.donee_names_for(@donor)
  end


end  
