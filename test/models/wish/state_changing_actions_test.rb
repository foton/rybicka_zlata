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

  



  private
  
    def stranger
      @starnger||=create_test_user!(name: "stranger")
    end  

end
