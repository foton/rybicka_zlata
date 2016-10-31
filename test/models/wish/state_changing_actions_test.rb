require 'test_helper'

class WishStateChangingActionsTest < ActiveSupport::TestCase
     
  def setup
    setup_wish
  end  

  def test_can_be_booked_by_donor
    msg=@wish.book!(@donor)

    assert @wish.booked?
    assert_equal @donor,@wish.booked_by_user 
    assert_equal "Přání 'My first wish' bylo zarezervováno pro 'donor'", msg
  end

  def test_cannot_be_booked_by_non_donors
    msg=@wish.book!(@author)
    refute @wish.booked?
    assert_equal nil, @wish.booked_by_user 

    msg=@wish.book!(@donee)
    refute @wish.booked?
    assert_equal nil, @wish.booked_by_user 

    msg=@wish.book!(stranger)
    refute @wish.booked?
    assert_equal nil, @wish.booked_by_user 
  end

  def test_unbook_wish_only_by_booking_user
    @wish.book!(@donor)
    assert_equal @donor, @wish.booked_by_user

    @wish.unbook!(@donee)
    assert @wish.booked?

    @wish.unbook!(@author)
    assert @wish.booked?

    @wish.unbook!(stranger)
    assert @wish.booked?

    msg=@wish.unbook!(@wish.booked_by_user)
    refute @wish.booked?
    assert_equal nil, @wish.booked_by_user 
    assert_equal "Přání 'My first wish' bylo uvolněno pro ostatní dárce.", msg
  end   

  def test_only_donor_can_set_call_for_co_donors
    msg=@wish.call_for_co_donors!(@author)
    refute @wish.call_for_co_donors?
    assert_equal nil, @wish.booked_by_user 

    msg=@wish.call_for_co_donors!(@donee)
    refute @wish.call_for_co_donors?
    assert_equal nil, @wish.booked_by_user 

    msg=@wish.call_for_co_donors!(stranger)
    refute @wish.call_for_co_donors?
    assert_equal nil, @wish.booked_by_user 

    msg=@wish.call_for_co_donors!(@donor)
    assert @wish.call_for_co_donors?
    assert_equal @donor,@wish.called_for_co_donors_by_user 
    assert_equal "Uživatel 'donor' hledá spoludárce pro přání 'My first wish'.", msg
  end

  def test_wish_in_call_for_co_donors_can_be_booked_by_some_else
    setup_donor2

    msg=@wish.call_for_co_donors!(@donor)
    assert @wish.call_for_co_donors?
    assert_equal @donor,@wish.called_for_co_donors_by_user 
    assert_equal "Uživatel 'donor' hledá spoludárce pro přání 'My first wish'.", msg

    msg=@wish.book!(@donor2)
   
    assert @wish.booked?
    assert_equal nil, @wish.called_for_co_donors_by_user 
    assert_equal @donor2, @wish.booked_by_user 
    assert_equal "Přání 'My first wish' bylo zarezervováno pro 'donor2'", msg

    msg=@wish.unbook!(@donor2)
   
    refute @wish.booked?
    assert_equal nil, @wish.called_for_co_donors_by_user 
    assert_equal nil, @wish.booked_by_user 
    assert_equal "Přání 'My first wish' bylo uvolněno pro ostatní dárce.", msg

  end

  def test_only_booked_by_user_can_set_gifted
    @wish.book!(@donor)
    assert_equal @donor, @wish.booked_by_user

    @wish.gifted!(@donee)
    refute @wish.gifted?
    
    @wish.gifted!(stranger)
    refute @wish.gifted?
         
    msg=@wish.gifted!(@donor)
    assert @wish.gifted?
    assert_equal @donor, @wish.booked_by_user 
    assert_equal "Přání 'My first wish' bylo darováno/splněno dárcem 'donor'.", msg
  end


  def test_only_donee_or_author_can_set_fulfilled
    @wish.book!(@donor)
    @wish.gifted!(@donor)
    assert @wish.gifted?
    
    msg=@wish.fulfilled!(@donor)
    refute @wish.fulfilled?

    msg=@wish.fulfilled!(stranger)
    refute @wish.fulfilled?
    
    msg=@wish.fulfilled!(@donee)
    assert @wish.fulfilled?
    assert_equal @donor, @wish.booked_by_user 
    assert_equal "Přání 'My first wish' bylo splněno.", msg

    #all_donor_links_are_deleted_on_fulfilling
    assert @wish.donor_links.empty?
  end

  

  private
  
    def stranger
      @stranger||=create_test_user!(name: "stranger")
    end  

end
