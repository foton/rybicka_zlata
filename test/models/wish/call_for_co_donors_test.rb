# frozen_string_literal: true

require 'test_helper'

class WishBookingTest < ActiveSupport::TestCase
  def setup
    prepare_wish_and_others
  end

  def test_when_available_no_called_id
    @wish.state = Wish::State::STATE_AVAILABLE
    @wish.called_for_co_donors_by_id = nil
    assert @wish.valid?

    @wish.called_for_co_donors_by_id = @donor.id
    assert_not @wish.valid?
    assert @wish.errors[:called_for_co_donors_by_id].present?
  end

  def test_cannot_be_called_by_author
    @wish.state = Wish::State::STATE_CALL_FOR_CO_DONORS
    @wish.called_for_co_donors_by_id = @author.id
    assert_not @wish.valid?
    assert @wish.errors[:called_for_co_donors_by_id].present?
  end

  def test_cannot_be_called_by_donee
    @wish.state = Wish::State::STATE_CALL_FOR_CO_DONORS
    @wish.called_for_co_donors_by_id = @donee.id
    assert_not @wish.valid?
    assert @wish.errors[:called_for_co_donors_by_id].present?
  end

  def test_cannot_be_in_call_for_co_donors_without_called_for_co_donors_by_id
    @wish.state = Wish::State::STATE_CALL_FOR_CO_DONORS

    @wish.called_for_co_donors_by_id = nil
    assert_not @wish.valid?
    assert @wish.errors[:called_for_co_donors_by_id].present?

    @wish.called_for_co_donors_by_id = @donor.id
    assert @wish.valid?, "errors: #{@wish.errors.full_messages}"
  end

  def test_may_be_set_for_other_states_then_available_and_called_for_co_donors
    [Wish::State::STATE_RESERVED, Wish::State::STATE_GIFTED, Wish::State::STATE_FULFILLED].each do |state|
      @wish.state = state
      @wish.booked_by_id = @donor.id
      @wish.called_for_co_donors_by_id = nil
      assert @wish.valid?, "#{@wish.state} errors: #{@wish.errors.full_messages}"

      @wish.called_for_co_donors_by_id = @donor.id
      assert @wish.valid?, "#{@wish.state} errors: #{@wish.errors.full_messages}"
    end
  end

  def test_can_be_fulfilled_without_called_for_co_donors_by_id
    @wish.state = Wish::State::STATE_FULFILLED

    @wish.called_for_co_donors_by_id = nil # can be fulfilled by person out of this app
    assert @wish.valid?

    @wish.called_for_co_donors_by_id = @donor.id # or from this app
    assert @wish.valid?
  end
end
