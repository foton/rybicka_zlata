# frozen_string_literal: true

require 'test_helper'

class DoneeWishListTest < ActiveSupport::TestCase
  def setup
    @bart = users(:bart)
    @homer = users(:homer)
    @lisa = users(:lisa)
    @marge = users(:marge)
  end

  def test_get_list_of_wishes_grouped_by_donee
    # see test/fixtures/fixture_consistency_test.rb
    expected_wishes = {
      @homer => [wishes(:marge_homer_holidays)],
      @lisa => [wishes(:lisa_tatoo)],
      @marge => [wishes(:marge_hairs), wishes(:marge_homer_holidays)]
    }
    donees = [@homer, @lisa, @marge]

    list = Wish::ListByDonees.new(@bart).all

    # list is ordered by donee.name ASC
    # wishes are ordered by updated_at DESC
    assert_equal donees.size, list.size

    donees.each_with_index do |donee, i|
      donee_list = list[i]

      assert_equal donee, donee_list[:user], "Wishes of #{donee} should be at #{i} place"
      # Comparing instances of Wish and Wish::FromAuthor, so I use IDs
      assert_equal expected_wishes[donee].collect(&:id) , donee_list[:wishes].collect(&:id)
    end
  end
end
