# frozen_string_literal: true

require 'test_helper'

class WishFromAuthorTest < ActiveSupport::TestCase
  def setup
    @author = users(:bart)

    @wish = Wish::FromAuthor.new(
      author: @author,
      title: 'My first wish',
      description: 'This is my first wish I am trying',
      donee_conn_ids: []
    )
  end

  def test_can_create_wish
    assert @wish.valid?
  end

  def test_cannot_create_wish_without_title
    @wish.title = ''
    assert_not @wish.valid?
    assert_equal ['je povinná položka', 'Tenhle Titulek je minimální až moc'], @wish.errors[:title]
  end

  def test_cannot_create_wish_without_author
    @wish.author = nil
    assert_not @wish.valid?
    assert_equal ['je povinná položka'], @wish.errors[:author]
  end

  def test_can_create_wish_without_description
    @wish.description = ''
    assert @wish.valid?
  end

  def test_can_create_wish_without_donors
    @wish.merge_donor_conn_ids([], @author)
    assert @wish.valid?
  end

  def test_can_create_wish_without_donees
    @wish.donee_conn_ids = []
    assert @wish.valid?
  end

  def test_add_donors_connections
    conn1 = connections(:bart_to_lisa)
    conn2 = connections(:bart_to_milhouse)
    @wish.merge_donor_conn_ids([conn1, conn2].collect(&:id), @author)

    assert @wish.save
    @wish.reload
    assert_equal [conn1, conn2].sort, @wish.donor_connections.sort
  end

  def test_add_donees_connections
    conn1 = connections(:bart_to_lisa)
    conn2 = connections(:bart_to_maggie)
    @wish.donee_conn_ids = [conn1, conn2].collect(&:id)

    assert @wish.save
    @wish.reload
    assert_equal [conn1, conn2, @author.base_connection].sort, @wish.donee_connections.sort
  end

  def test_cannot_have_same_donee_and_donor_connection
    conn1 = connections(:bart_to_lisa)
    conn2 = connections(:bart_to_maggie)
    conn3 = connections(:bart_to_milhouse)
    @wish.donee_conn_ids = [conn1, conn2].collect(&:id)
    @wish.merge_donor_conn_ids([conn1, conn3].collect(&:id), @author)

    assert_not @wish.valid?
    assert_equal ["Mezi obdarovanými je stejný kontakt jako v dárcích: '#{conn1.fullname}'."], @wish.errors[:donor_conn_ids]
    assert_equal ["Mezi obdarovanými je stejný kontakt jako v dárcích: '#{conn1.fullname}'."], @wish.errors[:donee_conn_ids]
  end

  def test_cannot_have_same_email_for_donee_and_donor
    conn1 = connections(:bart_to_lisa)
    conn2 = connections(:bart_to_maggie)
    conn3 = create_connection_for(@author, name: 'Lisa2', email: conn1.email)
    @wish.donee_conn_ids = [conn1].collect(&:id)
    @wish.merge_donor_conn_ids([conn2, conn3].collect(&:id), @author)

    assert_not @wish.valid?
    assert_equal ["Mezi obdarovanými je kontakt se stejným emailem jako jiná v dárcích: '#{conn3.email}'"], @wish.errors[:donor_conn_ids]
    assert_equal ["Mezi obdarovanými je kontakt se stejným emailem jako jiná v dárcích: '#{conn3.email}'"], @wish.errors[:donee_conn_ids]
  end

  def test_cannot_have_same_user_for_donee_and_donor
    to_lisa_conn = connections(:bart_to_lisa)
    to_maggie_conn = connections(:bart_to_maggie)
    to_milhouse_conn = connections(:bart_to_milhouse)

    hidden_lisa_email = 'hidden_lisa@gmail.com'
    User::Identity.create!(email: hidden_lisa_email, provider: 'google', user: users(:lisa), uid: 'lisag')

    to_hidden_lisa_conn = Connection.create!(email: hidden_lisa_email, name: 'Unknown beauty', friend: users(:lisa), owner: @author)
    @author.connections.reload

    @wish.donee_conn_ids = [to_lisa_conn].collect(&:id) # donees Bart + Lisa
    @wish.merge_donor_conn_ids([to_maggie_conn, to_milhouse_conn, to_hidden_lisa_conn].collect(&:id), @author) # donors: maggie, milhouse, hidden_lisa

    assert_not @wish.valid?
    assert_equal ["Mezi obdarovanými je stejný uživatel '#{to_lisa_conn.fullname}' jako v dárcích '#{to_hidden_lisa_conn.fullname}'."], @wish.errors[:donor_conn_ids]
    assert_equal ["Mezi obdarovanými je stejný uživatel '#{to_lisa_conn.fullname}' jako v dárcích '#{to_hidden_lisa_conn.fullname}'."], @wish.errors[:donee_conn_ids]
  end

  def test_set_updated_by_donee_at
    assert @wish.save
    updated_by_donee = @wish.updated_by_donee_at
    sleep 1.second
    @wish.title = 'new title'
    assert @wish.save
    assert((updated_by_donee + 1.second) < @wish.updated_by_donee_at)
  end

  def test_can_be_deleted_when_have_donors
    to_lisa_conn = connections(:bart_to_lisa)
    to_maggie_conn = connections(:bart_to_maggie)
    @wish.merge_donor_conn_ids([to_lisa_conn, to_maggie_conn].collect(&:id), @author)
    assert @wish.save
    @wish.reload

    assert_not DonorLink.for_wish(@wish).blank?

    @wish.destroy(@author)

    assert DonorLink.for_wish(@wish).blank?
    assert Wish.where(id: @wish.id).blank?
  end

  def test_can_be_deleted_when_have_donees
    to_lisa_conn = connections(:bart_to_lisa)
    to_maggie_conn = connections(:bart_to_maggie)
    @wish.donee_conn_ids = [to_lisa_conn.id, to_maggie_conn.id]
    assert @wish.save
    @wish.reload

    assert_not DoneeLink.for_wish(@wish).blank?

    @wish.destroy(@author)

    assert DoneeLink.for_wish(@wish).blank?
    assert Wish.where(id: @wish.id).blank?
  end

  def test_when_donee_is_kicked_out_all_his_connections_shoul_be_gone_too
    donee1 = users(:lisa)
    donee2 = users(:maggie)
    a_conn1 = connections(:bart_to_lisa)
    a_conn2 = connections(:bart_to_maggie)
    d1_conn = create_connection_for(donee1, name: 'George', email: 'george@beatles.com')
    d2_conn = create_connection_for(donee2, name: 'Ringo', email: 'ringo@beatles.com')

    @wish.donee_conn_ids = [a_conn1.id, a_conn2.id]
    assert @wish.save
    @wish.merge_donor_conn_ids([d1_conn.id], donee1)
    assert @wish.save
    @wish.merge_donor_conn_ids([d2_conn.id], donee2)
    assert @wish.save
    @wish.reload

    assert_equal [d1_conn, d2_conn].sort, @wish.donor_connections.sort

    # author desides to kick out donee1
    @wish.donee_conn_ids = @wish.donee_conn_ids - [a_conn1.id]
    assert @wish.valid?
    assert @wish.save
    @wish.reload
    @wish.donor_connections.reload

    # so d1_conn should be out of donors
    assert_equal [d2_conn].sort, @wish.donor_connections.sort
  end
end
