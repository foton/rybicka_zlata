# frozen_string_literal: true

require 'test_helper'

class DoneeWishListTest < ActiveSupport::TestCase
  def setup
    # three donees
    # mama have 1 personal + 1 shared wish (with tata)
    # bracha (brother) have 1 personal wish
    # tata have 1 shared wish (with mama)

    # one donor for all three doness is segra (sister)

    @mama = create_test_user!(name: 'mama')
    @tata = create_test_user!(name: 'tata')
    @bracha = create_test_user!(name: 'bracha')
    @segra = create_test_user!(name: 'segra')

    @mama_to_tata_conn = create_connection_for(@mama, name: 'mama_tata', email: @tata.email)
    @mama_to_segra_conn = create_connection_for(@mama, name: 'mama_segra', email: @segra.email)
    @mama_to_bracha_conn = create_connection_for(@mama, name: 'mama_bracha', email: @bracha.email)

    @tata_to_mama_conn = create_connection_for(@tata, name: 'tata_mama', email: @mama.email)
    @tata_to_segra_conn = create_connection_for(@tata, name: 'tata_segra', email: @segra.email)
    @tata_to_bracha_conn = create_connection_for(@tata, name: 'tata_bracha', email: @bracha.email)

    @bracha_to_segra_conn = create_connection_for(@bracha, name: 'bracha_segra', email: @segra.email)

    @wish_mama = Wish::FromAuthor.new(
      author: @mama,
      title: 'Mama personal wish',
      description: 'Just for segra. Mama is donee, Segra is donor.'
    )
    @wish_mama.merge_donor_conn_ids([@mama_to_segra_conn.id], @mama)
    @wish_mama.save!

    @wish_mama_tata = Wish::FromAuthor.new(
      author: @mama,
      title: 'Mama and Tata wish',
      description: 'Nice holiday without children. Mama and Tata are donees, Segra nad Bracha are donors.',
      donee_conn_ids: [@mama_to_tata_conn.id] # mama is added automagically as author
    )
    @wish_mama_tata.merge_donor_conn_ids([@mama_to_segra_conn.id], @mama)
    @wish_mama_tata.save!
    @wish_mama_tata.merge_donor_conn_ids([@tata_to_bracha_conn.id], @tata)
    @wish_mama_tata.save!

    @wish_bracha = Wish::FromAuthor.new(
      author: @bracha,
      title: 'Bracha personal wish',
      description: 'Nice holiday without parents and sister. Bracha is donee, Segra is donor.'
    )
    @wish_bracha.merge_donor_conn_ids([@bracha_to_segra_conn.id], @bracha)
    @wish_bracha.save!
  end

  def test_get_list_of_wishes_grouped_by_donee
    list = Wish::ListByDonees.new(@segra).all

    # list is ordered by donee.name ASC
    # wishes are ordered by updated_at DESC
    assert_equal 3, list.size
    assert_equal @bracha, list.first[:user]
    assert_equal @mama, list.second[:user]
    assert_equal @tata, list.last[:user]

    # compraing IDs, because @wish are of class FromAuthor, but in 'list' all wishes are FromDonor
    assert_equal  1, list.first[:wishes].size
    assert_equal  @wish_bracha.id, list.first[:wishes].last.id

    assert_equal  2, list.second[:wishes].size
    assert_equal @wish_mama_tata.id, list.second[:wishes].first.id
    assert_equal  @wish_mama.id, list.second[:wishes].last.id

    assert_equal  1, list.last[:wishes].size
    assert_equal  @wish_mama_tata.id, list.last[:wishes].last.id
  end
end
