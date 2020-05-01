# frozen_string_literal: true

require 'test_helper'

class WishIfosAboutWishTest < ActiveSupport::TestCase
  def setup
    @wish = wishes(:lisa_bart_bigger_car)
    @author = users(:lisa)
    @donor = users(:marge)
    @donee = users(:bart)
    @stranger = users(:maggie)
  end

  def test_know_its_author
    assert @wish.author?(@author)
    assert_not @wish.author?(@donee)
    assert_not @wish.author?(@donor)
    assert_not @wish.author?(@stranger)
  end

  def test_know_its_donees
    assert @wish.donee?(@author)
    assert @wish.donee?(@donee)
    assert_not @wish.donee?(@donor)
    assert_not @wish.donee?(@stranger)
  end

  def test_know_its_donors
    assert_not @wish.donor?(@author)
    assert_not @wish.donor?(@donee)
    assert @wish.donor?(@donor)
    assert_not @wish.donor?(@stranger)
  end

  def test_know_if_it_shared
    assert @wish.shared?

    @wish.donee_connections = [] # author will persist
    assert @wish.valid?

    assert_not @wish.shared?
  end

  def test_can_have_short_description
    limit = Wish::SHORT_DESCRIPTION_LENGTH
    description_in_limit = 'č' * limit
    description_over_limit = 'č' * (limit + 1)
    description_over_limit_with_space_part1 = ('ž' * (limit - 10))
    description_over_limit_with_space = description_over_limit_with_space_part1 + ' ' + ('č' * 10)

    @wish.description = description_in_limit
    assert_equal description_in_limit, @wish.description_shortened

    # nospace in description, size with dots aligned to limit
    @wish.description = description_over_limit
    assert_equal (description_over_limit[0..(limit - 4)] + ' ...'), @wish.description_shortened

    # should be shortened to last space + dots
    @wish.description = description_over_limit_with_space
    assert_equal (description_over_limit_with_space_part1 + ' ...'), @wish.description_shortened
  end

  def test_correct_styling_in_description
    url_with_comma = 'http://something.cz/path/to/file_with,should_be_safe'
    @wish.description = "Something,that should be fixed, right now. Or maybe,maybe not? #{url_with_comma}"
    assert @wish.valid?
    assert_equal "Something, that should be fixed, right now. Or maybe, maybe not? #{url_with_comma}", @wish.description
  end

  def test_available_donor_connections
    conns = @wish.donee_connections.to_a
    expected_conns = conns - ([@author.base_connection] + @wish.donee_connections.to_a)
    assert_equal expected_conns.to_a.sort, @wish.available_donor_connections_from(conns).to_a.sort
  end

  def test_available_donor_connections_exclude_connection_to_donees_by_user
    # when donee have connection with different email but pointing to same user
    # Author :   vilma [vilma@author.com]  friend_id: 3
    # Donee :    authors_vilma [a_vilma@donee.com] friend_id: 3
    # MamaUser[3]:  emails: vilma@author.com , a_vilma@donee.com
    vilma = create_user_with_emails('Vilma', %w[vilma@author.com a_vilma@donee.com])

    author_vilma_conn = create_connection_for(@author, name: 'Vilma', email: 'vilma@author.com')
    donee_a_vilma_conn = create_connection_for(@donee, name: 'a_vilma', email: 'a_vilma@donee.com')

    all_connections = @author.connections.reload + @donee.connections.reload
    assert_includes @wish.available_donor_connections_from(all_connections), author_vilma_conn
    assert_includes @wish.available_donor_connections_from(all_connections), donee_a_vilma_conn

    # now make Vilma one of the donees
    @wish.donee_connections += [author_vilma_conn]
    @wish.save!
    @wish.reload
    assert_equal [@author, @donee, vilma].sort, @wish.donee_connections.collect(&:friend).sort

    # from now Vilma cannot be available as donor
    all_connections = @author.connections.reload + @donee.connections.reload
    assert_not_includes @wish.available_donor_connections_from(all_connections), author_vilma_conn
    assert_not_includes @wish.available_donor_connections_from(all_connections), donee_a_vilma_conn
  end

  def test_available_donor_connections_exclude_connection_to_donees_by_email
    # when donee have connection with same email (without user) as author assigned as donee connection
    # Author :   vilma [a_vilma@email.cz]  friend_id: nil
    # Donee :    authors_vilma [a_vilma@email.cz] friend_id: nil
    # no MamaUser
    vilma_email = 'vilma@author.com'

    author_vilma_conn = create_connection_for(@author, name: 'Vilma', email: vilma_email)
    donee_a_vilma_conn = create_connection_for(@donee, name: 'a_vilma', email: vilma_email)

    available_donor_connections = @wish.available_donor_connections_from(@author.connections.reload + @donee.connections.reload)
    assert_includes available_donor_connections, author_vilma_conn
    assert_includes available_donor_connections, donee_a_vilma_conn

    # now author add Vilma as one of the donees
    @wish.donee_connections << author_vilma_conn
    @wish.reload

    # from now Vilma cannot be available as donor
    available_donor_connections = @wish.available_donor_connections_from(@author.connections + @donee.connections)
    assert_not_includes available_donor_connections, author_vilma_conn
    assert_not_includes available_donor_connections, donee_a_vilma_conn
  end

  def test_discover_complete_group_in_donors
    wish = wishes(:marge_hairs)
    expected_group_in_donors = groups(:marge_children)

    assert_equal [], wish.donor_groups_for(users(:lisa)), 'Group should not be found for Lisa'
    assert_equal [expected_group_in_donors], wish.donor_groups_for(users(:marge)), "Marge's group 'Children' should be found in donors"
  end

  def test_find_whole_groups_in_donees
    skip "lisa_to_bart uses different email than marge_to_bart"
    wish = wishes(:lisa_bart_bigger_car)

    assert_equal [], wish.donee_groups_for(users(:marge)), 'Group should be found yet for Marge, Maggie is missing'
    assert_equal [], wish.donee_groups_for(users(:lisa)), 'Group should not be found for Lisa'

    wish = Wish::FromAuthor.find(wish.id)
    wish.donee_conn_ids = wish.donee_conn_ids + [connections(:lisa_to_maggie), connections(:lisa_to_rachel)].collect(&:id)
    wish.save!

    assert_equal [groups(:marge_children)], wish.donee_groups_for(users(:marge)), 'Group should be found for Marge'
    assert_equal [], wish.donee_groups_for(users(:lisa)), 'Group should not be found for Lisa, she do not have such group.'
  end

  private

  def create_user_with_emails(name, emails)
    user = create_test_user!(name: name, email: emails.first)
    return user if emails.size == 1

    emails[1..-1].each do |email|
      User::Identity.create!(email: email,
                             user: user,
                             uid: '123456',
                             provider: User::Identity::LOCAL_PROVIDER)
    end
    user
  end
end
