# frozen_string_literal: true

require 'test_helper'

class WishFromAuthorTest < ActiveSupport::TestCase
  def setup
    @author = create_test_user!
    assert @author.base_connection.valid?

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
    refute @wish.valid?
    assert_equal ['je povinná položka'], @wish.errors[:title]
  end

  def test_cannot_create_wish_without_author
    @wish.author = nil
    refute @wish.valid?
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
    conn1 = Connection.create!(name: 'Simon', email: 'simon@says.com', owner_id: @author.id)
    conn2 = Connection.create!(name: 'Paul', email: 'Paul.Simon@says.com', owner_id: @author.id)
    @wish.merge_donor_conn_ids([conn1, conn2].collect(&:id), @author)

    assert @wish.save
    @wish.reload
    assert_equal [conn1, conn2].sort, @wish.donor_connections.sort
  end

  def test_add_donees_connections
    conn1 = Connection.create!(name: 'Simon', email: 'simon@says.com', owner_id: @author.id)
    conn2 = Connection.create!(name: 'Paul', email: 'Paul.Simon@says.com', owner_id: @author.id)
    @wish.donee_conn_ids = [conn1, conn2].collect(&:id)

    assert @wish.save
    @wish.reload
    assert_equal [conn1, conn2, @author.base_connection].sort, @wish.donee_connections.sort
  end

  def test_cannot_have_same_donee_and_donor_connection
    conn1 = Connection.create!(name: 'Simon', email: 'simon@says.com', owner_id: @author.id)
    conn2 = Connection.create!(name: 'Paul', email: 'Paul.Simon@says.com', owner_id: @author.id)
    conn3 = Connection.create!(name: 'John', email: 'john@beatles.com', owner_id: @author.id)
    @wish.donee_conn_ids = [conn1, conn2].collect(&:id)
    @wish.merge_donor_conn_ids([conn1, conn3].collect(&:id), @author)

    refute @wish.valid?
    assert_equal ["Mezi obdarovanými je stejná kontakt jako v dárcích: '#{conn1.fullname}'."], @wish.errors[:donor_conn_ids]
    assert_equal ["Mezi obdarovanými je stejná kontakt jako v dárcích: '#{conn1.fullname}'."], @wish.errors[:donee_conn_ids]
  end

  def test_cannot_have_same_email_for_donee_and_donor
    conn1 = Connection.create!(name: 'Simon', email: 'simon@says.com', owner_id: @author.id)
    conn2 = Connection.create!(name: 'Paul', email: 'Paul.Simon@says.com', owner_id: @author.id)
    conn3 = Connection.create!(name: 'Simon2', email: 'simon@says.com', owner_id: @author.id)
    @wish.donee_conn_ids = [conn1].collect(&:id)
    @wish.merge_donor_conn_ids([conn2, conn3].collect(&:id), @author)

    refute @wish.valid?
    assert_equal ["Mezi obdarovanými je kontakt se stejným emailem jako jiná v dárcích: '#{conn3.email}'"], @wish.errors[:donor_conn_ids]
    assert_equal ["Mezi obdarovanými je kontakt se stejným emailem jako jiná v dárcích: '#{conn3.email}'"], @wish.errors[:donee_conn_ids]
  end

  def test_cannot_have_same_user_for_donee_and_donor
    conn1 = Connection.create!(name: 'Simon', email: 'simon@says.com', owner_id: @author.id)
    conn2 = Connection.create!(name: 'Paul', email: 'Paul.Simon@says.com', owner_id: @author.id)
    conn3 = Connection.create!(name: 'John', email: 'john@beatles.com', owner_id: @author.id)

    user13 = create_test_user!(name: 'Simon and John', email: conn1.email)
    user13.identities << User::Identity.new(email: conn3.email, provider: User::Identity::LOCAL_PROVIDER)
    conn1.reload # to get user.name
    conn3.reload # to get user.name

    @wish.donee_conn_ids = [conn1].collect(&:id)
    @wish.merge_donor_conn_ids([conn2, conn3].collect(&:id), @author)

    refute @wish.valid?
    assert_equal ["Mezi obdarovanými je stejný uživatel '#{conn1.fullname}'  jako v dárcích '#{conn3.fullname}'."], @wish.errors[:donor_conn_ids]
    assert_equal ["Mezi obdarovanými je stejný uživatel '#{conn1.fullname}'  jako v dárcích '#{conn3.fullname}'."], @wish.errors[:donee_conn_ids]
  end

  def test_set_updated_by_donee_at
    assert @wish.save
    updated_by_donee = @wish.updated_by_donee_at
    sleep 1.second
    @wish.title = 'new title'
    assert @wish.save
    assert ((updated_by_donee + 1.second) < @wish.updated_by_donee_at)
  end

  def test_can_be_deleted_when_have_donors
    conn1 = Connection.create!(name: 'Simon', email: 'simon@says.com', owner_id: @author.id)
    conn2 = Connection.create!(name: 'Paul', email: 'Paul.Simon@says.com', owner_id: @author.id)
    @wish.merge_donor_conn_ids([conn1, conn2].collect(&:id), @author)
    assert @wish.save
    @wish.reload

    refute DonorLink.for_wish(@wish).blank?

    @wish.destroy(@author)

    assert DonorLink.for_wish(@wish).blank?
    assert Wish.where(id: @wish.id).blank?
  end

  def test_can_be_deleted_when_have_donees
    conn1 = Connection.create!(name: 'Simon', email: 'simon@says.com', owner_id: @author.id)
    conn2 = Connection.create!(name: 'Paul', email: 'Paul.Simon@says.com', owner_id: @author.id)
    @wish.donee_conn_ids = [conn1.id, conn2.id]
    assert @wish.save
    @wish.reload

    refute DoneeLink.for_wish(@wish).blank?

    @wish.destroy(@author)

    assert DoneeLink.for_wish(@wish).blank?
    assert Wish.where(id: @wish.id).blank?
  end

  def test_when_donee_is_kicked_out_all_his_connections_shoul_be_gone_too
    donee1 = create_test_user!(name: 'Donee Simon', email: 'simon@says.com')
    donee2 = create_test_user!(name: 'Donee Paul', email: 'paul.simon@says.com')
    a_conn1 = Connection.create!(name: 'Simon', email: donee1.email, owner_id: @author.id)
    a_conn2 = Connection.create!(name: 'Paul', email: donee2.email, owner_id: @author.id)
    d1_conn = Connection.create!(name: 'George', email: 'george@beatles.com', owner_id: donee1.id)
    d2_conn = Connection.create!(name: 'Ringo', email: 'ringo@beatles.com', owner_id: donee2.id)

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
