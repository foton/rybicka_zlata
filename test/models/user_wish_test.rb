# frozen_string_literal: true

require 'test_helper'

# for every test this class is freshly instantiated see http://chriskottom.com/blog/2014/10/4-fantastic-ways-to-set-up-state-in-minitest/

class UserWishTest < ActiveSupport::TestCase
  def setup
    OmniAuth.config.test_mode = true

    @user = create_test_user!(email: 'testme@dot.com')

    @mama = create_test_user!(name: 'Mama', email: 'mama@dot.com')
    @tata = create_test_user!(name: 'Tata', email: 'otecko@dot.com')

    setup_user_wishes
    setup_mama_wishes
    setup_tata_wishes
 end

  def test_know_his_all_kind_of_wishes
    # author wishes
    assert_equal [@author_wish1.id, @author_wish2.id].sort, @user.author_wishes.collect(&:id).sort # I do not care if it is Wish::FromAuthor or Wish::FromDonee or Wish::FromDonor
    # donee wishes
    assert_equal [@author_wish1.id, @author_wish2.id, @mama_shared_wish.id, @tata_shared_wish.id].sort, @user.donee_wishes.collect(&:id).sort
    # donor wishes
    assert_equal [@tata_wish.id, @mama_wish.id].sort, @user.donor_wishes.collect(&:id).sort
  end

  def test_deletes_all_authors_wishes_on_destroy
    a_wish_ids = @user.author_wishes.pluck(:id).to_a
    shared_wish_ids = (@user.donee_wishes.pluck(:id).to_a - a_wish_ids).sort

    assert a_wish_ids.present?
    assert shared_wish_ids.present?

    @user.destroy

    assert Wish.where(id: a_wish_ids).blank?
    sh_ws_ids = Wish.where(id: shared_wish_ids).pluck(:id).to_a.sort
    assert_equal shared_wish_ids, sh_ws_ids
  end

  private

  def setup_user_wishes
    conn_mama = create_connection_for(@user, name: 'Máma', email: @mama.email)
    conn_tata = create_connection_for(@user, name: 'Táta', email: @tata.email)

    @author_wish1 = Wish::FromAuthor.new(author: @user, title: 'Only my wish', description: 'This is my first wish I am trying')
    @author_wish1.merge_donor_conn_ids([conn_mama.id, conn_tata.id], @user)
    @author_wish1.save!
    # puts("author_wish1: #{@author_wish1.id}")

    @author_wish2 = Wish::FromAuthor.new(author: @user, title: 'second wish', description: 'I am still only donee')
    @author_wish2.merge_donor_conn_ids([conn_mama.id], @user)
    @author_wish2.save!
    # puts("author_wish1: #{@author_wish2.id}")
  end

  def setup_mama_wishes
    conn_user = create_connection_for(@mama, name: 'Syn', email: @user.email)
    conn_tata = create_connection_for(@mama, name: 'Manžel', email: @tata.email)

    @mama_shared_wish = Wish::FromAuthor.new(author: @mama, title: 'My shared wish with son', description: 'Me and my son are donees.')
    @mama_shared_wish.merge_donor_conn_ids([conn_tata.id], @mama)
    @mama_shared_wish.donee_conn_ids = [conn_user.id]
    @mama_shared_wish.save!
    # puts("mama_shared_wish: #{@mama_shared_wish.id}")

    @mama_wish = Wish::FromAuthor.new(author: @mama, title: 'Mama wish', description: 'I am only donee, others are donors')
    @mama_wish.merge_donor_conn_ids([conn_tata.id, conn_user.id], @mama)
    @mama_wish.save!
    # puts("mama_wish: #{@mama_wish.id}")
  end

  def setup_tata_wishes
    conn_user = create_connection_for(@tata, name: 'Syn', email: @user.email)
    conn_mama = create_connection_for(@tata, name: 'Manželka', email: @mama.email)

    @tata_shared_wish = Wish::FromAuthor.new(author: @tata, title: 'My shared wish with son', description: 'Me and my son are donees.')

    @tata_shared_wish.merge_donor_conn_ids([conn_mama.id], @tata)
    @tata_shared_wish.donee_conn_ids = [conn_user.id]
    @tata_shared_wish.save!
    # puts("tata_shared_wish: #{@tata_shared_wish.id}")

    @tata_wish = Wish::FromAuthor.new(author: @tata, title: 'Tata wish', description: 'I am only donee, others are donors')
    @tata_wish.merge_donor_conn_ids([conn_mama.id, conn_user.id], @tata)
    @tata_wish.save!
    # puts("tata_wish: #{@tata_wish.id}")
  end
end
