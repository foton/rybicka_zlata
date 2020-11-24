# frozen_string_literal: true

require 'test_helper'

class WishFromDoneeTest < ActiveSupport::TestCase
  def setup
    @author = users(:lisa)
    @donee = users(:bart)
    a_shared_wish = wishes(:lisa_bart_bigger_car)

    @conn1 = connections(:lisa_to_homer)
    @conn2 = connections(:lisa_to_marge)
    @author_to_donee_conn = connections(:lisa_to_bart)

    @shared_wish = Wish::FromDonee.find(a_shared_wish.id)
  end

  def test_cannot_update_wish_without_title
    @shared_wish.title = ''
    assert_not @shared_wish.valid?
    assert_equal ["je povinná položka", "Tenhle Titulek je minimální až moc"], @shared_wish.errors[:title]
  end

  def test_cannot_update_wish_without_author
    @shared_wish.author = nil
    assert_not @shared_wish.valid?
    assert_equal ['je povinná položka'], @shared_wish.errors[:author]
  end

  def test_can_update_wish_without_description
    @shared_wish.description = ''
    assert @shared_wish.valid?
  end

  def test_add_donors_connections_and_remove_only_them
    conn_jpb = create_connection_for(@donee, name: 'Jean Paul', email: 'belmondo@paris.fr')
    conn_jr = create_connection_for(@donee, name: 'Jean Reno', email: 'reno@paris.fr')
    time_before = Time.current
    assert_not @shared_wish.changed?

    @shared_wish.merge_donor_conn_ids([conn_jpb.id], @donee)

    assert @shared_wish.changed?
    assert @shared_wish.save

    @shared_wish.reload

    assert_not @shared_wish.changed?
    assert_equal [@conn1, @conn2, conn_jpb].sort, @shared_wish.donor_connections.sort

    @shared_wish.merge_donor_conn_ids([@conn2.id, conn_jr.id], @donee)
    assert @shared_wish.save
    @shared_wish.reload

    # @conn1 is not removed, just conn_jpb
    assert_equal [@conn1, @conn2, conn_jr].sort, @shared_wish.donor_connections.sort
    assert @shared_wish.updated_by_donee_at > time_before
    assert @shared_wish.updated_by_donee_at < Time.current
  end

  def test_can_remove_yourself_from_donees_by_call_for_destroy
    assert @donee.donee_wishes.include?(@shared_wish)

    @shared_wish.destroy(@donee)

    assert_not @donee.donee_wishes.include?(@shared_wish)
    assert @author.donee_wishes.include?(@shared_wish)
  end

  def test_cannot_change_donees_connections_only_donors_connections
    assert_equal [@author.base_connection, @author_to_donee_conn].sort, @shared_wish.donee_connections.sort

    conn_jpb = create_connection_for(@donee, name: 'Jean Paul', email: 'belmondo@paris.fr')
    @shared_wish.donee_conn_ids = [conn_jpb.id]
    assert @shared_wish.save # just silently ignoring attempt to add donees
    @shared_wish.reload

    assert_equal [@author.base_connection, @author_to_donee_conn].sort, @shared_wish.donee_connections.sort
  end
end
