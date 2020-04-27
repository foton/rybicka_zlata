# frozen_string_literal: true

require 'test_helper'

class UserWishTest < ActiveSupport::TestCase
  def setup
    OmniAuth.config.test_mode = true

    @bart = users(:bart)
  end

  def test_know_his_all_kind_of_wishes
    # author wishes
    assert_equal [wishes(:bart_skateboard).id, wishes(:bart_motorbike).id, wishes(:lisa_bart_bigger_car).id].sort,
                 @bart.author_wishes.collect(&:id).sort
    # donee wishes
    assert_equal [wishes(:bart_skateboard).id, wishes(:bart_motorbike).id, wishes(:lisa_bart_bigger_car).id].sort,
                 @bart.donee_wishes.collect(&:id).sort
    # donor wishes
    assert_equal [wishes(:marge_hairs).id, wishes(:marge_homer_holidays).id, wishes(:lisa_tatoo).id].sort,
                 @bart.donor_wishes.collect(&:id).sort
  end

  def test_deletes_all_authors_wishes_on_destroy
    author_wishes_ids = @bart.author_wishes.pluck(:id)

    assert_difference('Wish.count', -1 * author_wishes_ids.size) do
      @bart.destroy
    end

    assert Wish.where(id: author_wishes_ids).blank?
  end
end
