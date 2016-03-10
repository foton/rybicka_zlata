require 'test_helper'

class WishBookingTest < ActiveSupport::TestCase
     
  def setup
    setup_wish
  end  

  def test_when_available_no_booked_id
    @wish.state=Wish::State::STATE_AVAILABLE
    @wish.booked_by_id=nil
    assert @wish.valid?

    @wish.booked_by_id=@donor.id
    refute @wish.valid?
    assert @wish.errors[:booked_by_id].present?
  end  

  def test_cannot_be_booked_by_author
    @wish.state=Wish::State::STATE_RESERVED
    @wish.booked_by_id=@author.id
    refute @wish.valid?
    assert @wish.errors[:booked_by_id].present?
  end  

  def test_cannot_be_booked_by_donee
    @wish.state=Wish::State::STATE_RESERVED
    @wish.booked_by_id=@donee.id
    refute @wish.valid?
    assert @wish.errors[:booked_by_id].present?
  end  
  
  def test_cannot_be_booked_without_booked_by_id
    @wish.state=Wish::State::STATE_RESERVED

    @wish.booked_by_id=nil
    refute @wish.valid?
    assert @wish.errors[:booked_by_id].present?

    @wish.booked_by_id=@donor.id
    assert @wish.valid?
  end 
 
  def test_cannot_be_gifted_without_booked_by_id
    @wish.state=Wish::State::STATE_GIFTED

    @wish.booked_by_id=nil
    refute @wish.valid?
    assert @wish.errors[:booked_by_id].present?

    @wish.booked_by_id=@donor.id
    assert @wish.valid?
  end 

  def test_can_be_fulfilled_without_booked_by_id
    @wish.state=Wish::State::STATE_FULFILLED

    @wish.booked_by_id=nil  #can be fulfilled by person out of this app
    assert @wish.valid?  
    
    @wish.booked_by_id=@donor.id #or from this app
    assert @wish.valid?
  end 
end  
