# frozen_string_literal: true

require 'test_helper'

class WishFromDonorTest < ActiveSupport::TestCase
  # IF donee_connection links to user (aka friend)?
  #    a) user (donor) have it's own connection to that friend => display connection.name
  #    b) user (donor) do not have such connection => display friend.displayed_name
  # ELSE # donee_connection do not have friend
  #    c) user (donor) have it's own connection with same email as in donee_connection => display connection.name
  #    d) user (donor) do not have such connection => display donee_connection.name

  def test_donor_see_displayed_names_if_no_connection_between
    # a) and b) form above
    shared_wish = Wish::FromDonor.find(wishes(:lisa_bart_bigger_car).id)
    donor = users(:homer) # have connection only to Bart

    expected_names = [users(:lisa).displayed_name, connections(:homer_to_bart).name].sort
    assert_equal expected_names, shared_wish.donee_names_for(donor)
  end

  def test_donor_see_connection_names_if_there_are_connections_to_donnees
    # c) and d) from above =>  Jenny is not user
    wish = wishes(:marge_hairs)
    wish_from_donor = Wish::FromDonor.find(add_jenny_as_donee_to(wish).id)

    # Donor Bart have connection to jenny
    expected_names = [connections(:bart_to_marge).name, connections(:bart_to_jenny).name].sort
    assert_equal expected_names, wish_from_donor.donee_names_for(users(:bart))

    # Donor Lisa do not have connection to Jenny, so no Jenny between donees
    expected_names = [connections(:lisa_to_marge).name]
    assert_equal expected_names, wish_from_donor.donee_names_for(users(:lisa))
  end

  private

  def add_jenny_as_donee_to(wish)
    jennys_email = connections(:bart_to_jenny).email
    marge_to_jenny_conn = create_connection_for(wish.author, name: 'Jenny junior', email: jennys_email)
    # add Jenny as second donee to :marge_hairs
    wish_from_donor = Wish::FromAuthor.find(wish.id)
    wish_from_donor.donee_connections << marge_to_jenny_conn

    wish_from_donor
  end
end
