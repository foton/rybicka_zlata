require 'test_helper'

class WishIfosAboutWishTest < ActiveSupport::TestCase
  def setup
    setup_wish
    @stranger = create_test_user!(name: "stranger")
  end  

  def test_know_its_author
    assert @wish.is_author?(@author)
    refute @wish.is_author?(@donee)
    refute @wish.is_author?(@donor)
    refute @wish.is_author?(@stranger)
  end
  
  def test_know_its_donees
    assert @wish.is_donee?(@author)
    assert @wish.is_donee?(@donee)
    refute @wish.is_donee?(@donor)
    refute @wish.is_donee?(@stranger)
  end

  def test_know_its_donors
    refute @wish.is_donor?(@author)
    refute @wish.is_donor?(@donee)
    assert @wish.is_donor?(@donor)
    refute @wish.is_donor?(@stranger)
  end  

  def test_know_if_it_shared
    assert @wish.is_shared?
    @wish.donee_conn_ids=[] #author will persist
    @wish.valid?
    refute @wish.is_shared?
  end  

  def test_can_short_description
    limit=100
    description_in_limit="č"*limit
    description_over_limit="č"*(limit+1)
    description_over_limit_with_space_part1=("ž"*(limit-10))
    description_over_limit_with_space=description_over_limit_with_space_part1+" "+("č"*10)
     
    @wish.description=description_in_limit
    assert_equal description_in_limit, @wish.description_shortened
    
    #nospace in description, size with dots aligned to limit
    @wish.description=description_over_limit
    assert_equal (description_over_limit[0..(limit-5)]+" ..."), @wish.description_shortened     
    
    #should be shortened to last space + dots
    @wish.description=description_over_limit_with_space
    assert_equal (description_over_limit_with_space_part1+" ..."), @wish.description_shortened     
  end

  def test_know_available_donor_connections
    conns=@author.connections.to_a
    expected_conns=conns-([@author.base_connection]+@wish.donee_connections.to_a)
    assert_equal expected_conns.to_a.sort, @wish.available_donor_connections_from(conns).to_a.sort
  end  
    
  def test_know_available_donor_connections_when_different_emails_points_to_same_donee_user
    #when author/donee have connection with different email but pointing on donee user
    # Author :   mama [mama@author.com]  friend_id: 3
    # Donee :    authors_mama [a_mama@donee.com] friend_id: 3
    # MamaUser[3]:  emails: mama@author.com , a_mama@donee.com
    mama=create_test_user!(name: "mama", email: "mama@author.com")
    idnt=User::Identity.create(uid: "123456", provider: User::Identity::LOCAL_PROVIDER, email: "a_mama@donee.com")
    idnt.user=mama
    idnt.save!

    author_mama_conn=create_connection_for(@author, {name: "mama", email: mama.email})  
    @author.connections.reload
    assert_equal [@donor_conn, @donee_conn, @author.base_connection, author_mama_conn].sort, @author.connections.to_a.sort

    @wish.donee_conn_ids+=[author_mama_conn.id]
    @wish.save!
    @wish.reload
    assert_equal [@author.base_connection, @donee_conn, author_mama_conn].sort, @wish.donee_connections.to_a.sort

    donee_a_mama_conn=create_connection_for(@donee, {name: "a_mama", email: idnt.email})  
    donor_for_donee_conn=create_connection_for(@donee, {name: "donee_donor"})  
    @donee.connections.reload
    assert_equal [@donee.base_connection, donee_a_mama_conn, donor_for_donee_conn].sort, @donee.connections.to_a.sort
    
    conns=@donee.connections.to_a + @author.connections.to_a
    expected_conns=[@donor_conn, donor_for_donee_conn]
    assert_equal expected_conns.to_a.sort, @wish.available_donor_connections_from(conns).to_a.sort
  end

  def test_know_available_donor_connections_when_matching_emails_in_different_connections

    #when donne have connection with same email (without user) as author assigned as donee connection
    # Author :   mama [a_mama@email.cz]  friend_id: nil
    # Donee :    authors_mama [a_mama@email.cz] friend_id: nil
    #no MamaUser
    mama_email="a_mama@email.cz"

    author_mama_conn=create_connection_for(@author, {name: "mama", email: mama_email})  
    @author.connections.reload
    assert_equal [@donor_conn, @donee_conn, @author.base_connection, author_mama_conn].sort, @author.connections.to_a.sort

    @wish.donee_conn_ids+=[author_mama_conn.id]
    @wish.save!
    @wish.reload
    assert_equal [@author.base_connection, @donee_conn, author_mama_conn].sort, @wish.donee_connections.to_a.sort

    donee_a_mama_conn=create_connection_for(@donee, {name: "a_mama", email: mama_email})  
    donor_for_donee_conn=create_connection_for(@donee, {name: "donee_donor"})  
    @donee.connections.reload
    assert_equal [@donee.base_connection, donee_a_mama_conn, donor_for_donee_conn].sort, @donee.connections.to_a.sort
    
    assert author_mama_conn.friend_id.nil?
    assert donee_a_mama_conn.friend_id.nil?

    conns=@donee.connections.to_a + @author.connections.to_a
    expected_conns=[@donor_conn, donor_for_donee_conn]
    assert_equal expected_conns.to_a.sort, @wish.available_donor_connections_from(conns).to_a.sort
  end    
end
