# frozen_string_literal: true

require 'test_helper'

class WishStateChangingActionsTest < ActiveSupport::TestCase
  def setup
    @wish = wishes(:lisa_bart_bigger_car)
    @author = @wish.author
    @donor = users(:marge)
    @donor2 = users(:homer)
    @donee = users(:bart)
    @stranger = users(:maggie)
  end

  def test_can_be_booked_by_donor
    msg = @wish.book!(@donor)

    assert @wish.booked?
    assert_equal @donor, @wish.booked_by_user
    assert_equal "Přání '#{@wish.title}' bylo zarezervováno pro '#{@donor.name}'", msg
  end

  def test_cannot_be_booked_by_non_donors
    @wish.book!(@author)
    assert_not @wish.booked?
    assert_nil @wish.booked_by_user

    @wish.book!(@donee)
    assert_not @wish.booked?
    assert_nil @wish.booked_by_user

    @wish.book!(@stranger)
    assert_not @wish.booked?
    assert_nil @wish.booked_by_user
  end

  def test_unbook_wish_only_by_booking_user
    @wish.book!(@donor)
    assert_equal @donor, @wish.booked_by_user

    @wish.unbook!(@donee)
    assert @wish.booked?

    @wish.unbook!(@author)
    assert @wish.booked?

    @wish.unbook!(@stranger)
    assert @wish.booked?

    msg = @wish.unbook!(@wish.booked_by_user)
    assert_not @wish.booked?
    assert_nil @wish.booked_by_user
    assert_equal "Přání '#{@wish.title}' bylo uvolněno pro ostatní dárce.", msg
  end

  def test_only_donor_can_set_call_for_co_donors
    @wish.call_for_co_donors!(@author)
    assert_not @wish.call_for_co_donors?
    assert_nil @wish.booked_by_user

    @wish.call_for_co_donors!(@donee)
    assert_not @wish.call_for_co_donors?
    assert_nil @wish.booked_by_user

    @wish.call_for_co_donors!(@stranger)
    assert_not @wish.call_for_co_donors?
    assert_nil @wish.booked_by_user

    msg = @wish.call_for_co_donors!(@donor)
    assert @wish.call_for_co_donors?
    assert_equal @donor, @wish.called_for_co_donors_by_user
    assert_equal "Uživatel '#{@donor.name}' hledá spoludárce pro přání '#{@wish.title}'. Ozvěte se mu.", msg
  end

  def test_wish_in_call_for_co_donors_can_be_booked_by_some_else
    msg = @wish.call_for_co_donors!(@donor)
    assert @wish.call_for_co_donors?
    assert_equal @donor, @wish.called_for_co_donors_by_user
    assert_equal "Uživatel '#{@donor.name}' hledá spoludárce pro přání '#{@wish.title}'. Ozvěte se mu.", msg

    msg = @wish.book!(@donor2)

    assert @wish.booked?
    assert_nil @wish.called_for_co_donors_by_user
    assert_equal @donor2, @wish.booked_by_user
    assert_equal "Přání '#{@wish.title}' bylo zarezervováno pro '#{@donor2.name}'", msg

    msg = @wish.unbook!(@donor2)

    assert_not @wish.booked?
    assert_nil @wish.called_for_co_donors_by_user
    assert_nil @wish.booked_by_user
    assert_equal "Přání '#{@wish.title}' bylo uvolněno pro ostatní dárce.", msg
  end

  def test_only_booked_by_user_can_set_gifted
    @wish.book!(@donor)
    assert_equal @donor, @wish.booked_by_user

    @wish.gifted!(@donee)
    assert_not @wish.gifted?

    @wish.gifted!(@stranger)
    assert_not @wish.gifted?

    msg = @wish.gifted!(@donor)
    assert @wish.gifted?
    assert_equal @donor, @wish.booked_by_user
    assert_equal "Přání '#{@wish.title}' bylo darováno/splněno dárcem '#{@donor.name}'.", msg
  end

  def test_only_donee_or_author_can_set_fulfilled
    @wish.book!(@donor)
    @wish.gifted!(@donor)
    assert @wish.gifted?

    msg = @wish.fulfilled!(@donor)
    assert_not @wish.fulfilled?

    msg = @wish.fulfilled!(@stranger)
    assert_not @wish.fulfilled?

    msg = @wish.fulfilled!(@donee)
    assert @wish.fulfilled?
    assert_equal @donor, @wish.booked_by_user
    assert_equal "Přání '#{@wish.title}' bylo splněno.", msg

    # all_donor_links_are_deleted_on_fulfilling
    assert @wish.donor_links.empty?
  end
end
