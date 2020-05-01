# frozen_string_literal: true

require 'test_helper'

class Wishes::FromDonorControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]

    @bart = users(:bart)
    @homer = users(:homer)
    @lisa = users(:lisa)
    @marge = users(:marge)

    @bart_as_donor_wishes = [
      [@homer, [Wish::FromDonor.find(wishes(:marge_homer_holidays).id)]],
      [@lisa,  [Wish::FromDonor.find(wishes(:lisa_tatoo).id)]],
      [@marge, [Wish::FromDonor.find(wishes(:marge_hairs).id),
                Wish::FromDonor.find(wishes(:marge_homer_holidays).id)]]
    ]
    @marge_wish = Wish::FromDonor.find(wishes(:marge_hairs).id)

    sign_in @bart
  end

  def test_index_of_wishes_to_fulfill
    get :index, params: { user_id: @bart.id }

    assert assigns(:wishes_by_donees).present?
    assert_equal @bart_as_donor_wishes, assigns(:wishes_by_donees).to_a
    assert_template 'index'
    assert_not_nil assigns(:user)
  end

  def test_cannot_see_donor_wishes_for_other_user_account
    get :index, params: { user_id: @marge.id }

    assert_response :redirect
    assert_redirected_to user_others_wishes_url(@bart)
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_index_no_wish_yet
    user = users(:burns)
    assert user.donor_wishes.blank?

    sign_in user

    get :index, params: { user_id: user.id }

    assert_equal [], assigns(:wishes_by_donees).to_a
    assert_template 'index'
    assert_not_nil assigns(:user)
    assert_equal user, assigns(:user)
  end

  def test_show_wish
    get :show, params: { user_id: @bart.id, id: @marge_wish.id }

    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).is_a?(Wish::FromDonor)
    assert_equal @marge_wish, assigns(:wish)
  end

  def test_update
    # update just call method wish.do_action! from 'state_action=do_action' if it is allowed to user

    # for example do_action=book
    patch :update, params: { user_id: @bart.id, id: @marge_wish.id, state_action: :book }

    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).is_a?(Wish::FromDonor)
    assert_equal @marge_wish, assigns(:wish)
    assert_equal "Přání 'M: Taller hairs' bylo zarezervováno pro 'Bartholomew JoJo Simpson'", flash[:notice]

    @marge_wish.reload
    assert @marge_wish.booked?
    assert @marge_wish.booked_by?(@bart)
  end

  def test_do_not_update_if_action_is_not_allowed_to_user
    # update just call method wish.do_action! from 'state_action=do_action' if it is allowed to user

    # for example do_action=fulfilled is reserved for donees
    patch :update, params: { user_id: @bart.id, id: @marge_wish.id, state_action: :fulfilled }

    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).is_a?(Wish::FromDonor)
    assert_equal @marge_wish, assigns(:wish)
    assert_nil flash[:notice]

    @marge_wish.reload
    refute @marge_wish.fulfilled?
  end
end
