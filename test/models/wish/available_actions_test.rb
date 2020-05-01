# frozen_string_literal: true

require 'test_helper'

class WishAvailableActionsTest < ActiveSupport::TestCase
  def setup
    prepare_wish_and_others
  end

  def test_action_from_authors_side
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@author)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@author)

    @wish.book!(@donor)
    # do not test the state of wish, this is internall stuff
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@author)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@author)

    @wish.unbook!(@donor)
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@author)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@author)

    @wish.call_for_co_donors!(@donor)
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@author)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@author)

    @wish.book!(@donor)
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@author)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@author)

    @wish.gifted!(@donor)
    assert_equal [:fulfilled], @wish.available_actions_for(@author)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@author)

    @wish.fulfilled!(@author)
    assert_equal [], @wish.available_actions_for(@author)
    assert_equal [], @wish.available_state_actions_for(@author)
  end

  def test_action_from_donee_side
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@donee)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@donee)

    @wish.book!(@donor)
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@donee)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@donee)

    @wish.unbook!(@donor)
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@donee)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@donee)

    @wish.call_for_co_donors!(@donor)
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@donee)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@donee)

    @wish.book!(@donor)
    assert_equal %i[show edit delete fulfilled], @wish.available_actions_for(@donee)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@donee)

    @wish.gifted!(@donor)
    assert_equal [:fulfilled], @wish.available_actions_for(@donee)
    assert_equal [:fulfilled], @wish.available_state_actions_for(@donee)

    @wish.fulfilled!(@donee)
    assert_equal [], @wish.available_actions_for(@donee)
    assert_equal [], @wish.available_state_actions_for(@donee)
  end

  def test_action_from_donor_side
    assert_equal %i[show book call_for_co_donors], @wish.available_actions_for(@donor)
    assert_equal %i[book call_for_co_donors], @wish.available_state_actions_for(@donor)

    @wish.book!(@donor)
    assert_equal %i[show unbook gifted], @wish.available_actions_for(@donor)
    assert_equal %i[unbook gifted], @wish.available_state_actions_for(@donor)

    @wish.unbook!(@donor)
    assert_equal %i[show book call_for_co_donors], @wish.available_actions_for(@donor)
    assert_equal %i[book call_for_co_donors], @wish.available_state_actions_for(@donor)

    @wish.book!(@donor)
    assert_equal %i[show unbook gifted], @wish.available_actions_for(@donor)
    assert_equal %i[unbook gifted], @wish.available_state_actions_for(@donor)

    @wish.gifted!(@donor)
    assert_equal [], @wish.available_actions_for(@donor)
    assert_equal [], @wish.available_state_actions_for(@donor)

    @wish.fulfilled!(@author)
    assert_equal [], @wish.available_actions_for(@donor)
    assert_equal [], @wish.available_state_actions_for(@donor)
  end

  def test_action_from_donor_side_with_co_donors
    assert_equal %i[show book call_for_co_donors], @wish.available_actions_for(@donor)
    assert_equal %i[book call_for_co_donors], @wish.available_state_actions_for(@donor)

    @wish.call_for_co_donors!(@donor)
    assert_equal %i[show withdraw_call book], @wish.available_actions_for(@donor)
    assert_equal %i[withdraw_call book], @wish.available_state_actions_for(@donor)

    @wish.withdraw_call!(@donor)
    assert_equal %i[show book call_for_co_donors], @wish.available_actions_for(@donor)
    assert_equal %i[book call_for_co_donors], @wish.available_state_actions_for(@donor)

    @wish.call_for_co_donors!(@donor)
    assert_equal %i[show withdraw_call book], @wish.available_actions_for(@donor)
    assert_equal %i[withdraw_call book], @wish.available_state_actions_for(@donor)

    @wish.book!(@donor)
    assert_equal %i[show unbook gifted], @wish.available_actions_for(@donor)
    assert_equal %i[unbook gifted], @wish.available_state_actions_for(@donor)

    @wish.gifted!(@donor)
    assert_equal [], @wish.available_actions_for(@donor)
    assert_equal [], @wish.available_state_actions_for(@donor)

    @wish.fulfilled!(@author)
    assert_equal [], @wish.available_actions_for(@donor)
    assert_equal [], @wish.available_state_actions_for(@donor)
  end

  def test_action_from_another_donor
    another_donor = create_test_user!(name: 'a_donor')
    adonor_conn = create_connection_for(@author, name: 'a_donor_conn', email: another_donor.email)

    author_wish = Wish::FromAuthor.find(@wish.id)
    author_wish.merge_donor_conn_ids([adonor_conn.id], @author)
    author_wish.save!

    @wish.reload

    # even when call for co-donors is in place, another donor can overtake the wish by booking
    @wish.call_for_co_donors!(@donor)
    assert_equal %i[show book], @wish.available_actions_for(another_donor)
    assert_equal [:book], @wish.available_state_actions_for(another_donor)

    @wish.withdraw_call!(@donor)
    assert_equal %i[show book call_for_co_donors], @wish.available_actions_for(another_donor)
    assert_equal %i[book call_for_co_donors], @wish.available_state_actions_for(another_donor)

    @wish.book!(@donor)
    assert_equal [], @wish.available_actions_for(another_donor)
    assert_equal [], @wish.available_state_actions_for(another_donor)

    @wish.gifted!(@donor)
    assert_equal [], @wish.available_actions_for(another_donor)
    assert_equal [], @wish.available_state_actions_for(another_donor)

    @wish.fulfilled!(@author)
    assert_equal [], @wish.available_actions_for(another_donor)
    assert_equal [], @wish.available_state_actions_for(another_donor)
  end

  def test_no_actions_if_you_are_not_donee_or_potencial_donor
    bfu = create_test_user!
    refute (bfu.donee_wishes + bfu.donor_wishes).include?(@wish)

    assert_equal [], @wish.available_actions_for(bfu)
    assert_equal [], @wish.available_state_actions_for(bfu)

    @wish.call_for_co_donors!(@donor)
    assert_equal [], @wish.available_actions_for(bfu)
    assert_equal [], @wish.available_state_actions_for(bfu)

    @wish.unbook!(@donor)
    assert_equal [], @wish.available_actions_for(bfu)
    assert_equal [], @wish.available_state_actions_for(bfu)

    @wish.call_for_co_donors!(@donor)
    assert_equal [], @wish.available_actions_for(bfu)
    assert_equal [], @wish.available_state_actions_for(bfu)

    @wish.book!(@donor)
    assert_equal [], @wish.available_actions_for(bfu)
    assert_equal [], @wish.available_state_actions_for(bfu)

    @wish.gifted!(@donor)
    assert_equal [], @wish.available_actions_for(bfu)
    assert_equal [], @wish.available_state_actions_for(bfu)

    @wish.fulfilled!(@author)
    assert_equal [], @wish.available_actions_for(bfu)
    assert_equal [], @wish.available_state_actions_for(bfu)
  end
end
