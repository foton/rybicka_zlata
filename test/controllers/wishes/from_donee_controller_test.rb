# frozen_string_literal: true

require 'test_helper'

class Wishes::FromDoneeControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @bart = users(:bart)
    sign_in @bart

    @conn_mom = connections(:bart_to_marge)
    @conn_dad = connections(:bart_to_homer)
    @conn_lisa = connections(:bart_to_lisa)

    @shared_wish = Wish::FromDonee.find(wishes(:lisa_bart_bigger_car).id)
    @author_wish = Wish::FromDonee.find(wishes(:bart_skateboard).id)
    @fulfilled_wish = Wish::FromDonee.find(wishes(:bart_motorbike).id)
    @fulfilled_wish.fulfilled!(@bart)
    @fulfilled_wish.save!

    @barts_wishes = [@author_wish,
                     @shared_wish,
                     Wish::FromDonee.find(wishes(:bart_homer_new_car).id),
                     @fulfilled_wish]
  end

  def test_index_of_my_fulfilled_wishes
    get :index, params: { user_id: @bart.id, fulfilled: 1 }

    assert assigns(:wishes).present?
    assert_equal [@fulfilled_wish], assigns(:wishes).to_a
    assert_template 'index_fulfilled'
    assert_not_nil assigns(:user)
  end

  def test_index_of_my_notfulfilled_wishes
    get :index, params: { user_id: @bart.id }

    assert assigns(:wishes).present?
    assert_equal (@barts_wishes.to_a - [@fulfilled_wish]), assigns(:wishes).to_a
    assert_template 'index'
    assert_not_nil assigns(:user)
  end

  def test_index_no_wish_yet
    Wish.destroy_all
    assert @bart.donee_wishes.blank?

    get :index, params: { user_id: @bart.id }

    assert_equal [], assigns(:wishes)
    assert_template 'index'
    assert_not_nil assigns(:user)
  end

  def test_show_of_my_own_wish
    get :show, params: { user_id: @bart.id, id: @author_wish.id }

    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).is_a?(Wish::FromDonee)
    assert_equal @author_wish, assigns(:wish)
  end

  def test_show_of_shared_wish
    get :show, params: { user_id: @bart.id, id: @shared_wish.id }

    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).is_a?(Wish::FromDonee)
    assert_equal @shared_wish, assigns(:wish)
  end

  def test_edit_shared_wish
    bart_conns = @bart.friend_connections

    get :edit, params: { user_id: @bart.id, id: @shared_wish.id }

    assert_not_nil assigns(:wish)
    assert_equal @shared_wish, assigns(:wish)

    assert_not_nil assigns(:user_connections)
    assert_equal bart_conns, assigns(:user_connections)

    assert_not_nil assigns(:user_groups)
    assert_equal @bart.groups, assigns(:user_groups)

    assert_not_nil assigns(:available_donor_connections)
    # Lisa is donee/author, so it cannot be assigned as donor
    assert_equal (bart_conns.to_a - [connections(:bart_to_lisa)]), assigns(:available_donor_connections)
  end

  def test_can_only_change_donors_at_shared_wish
    # donee can change only donors from his connections

    bart_to_maggie_conn = connections(:bart_to_maggie)
    bart_to_marge_conn = connections(:bart_to_marge)
    bart_to_homer_conn = connections(:bart_to_homer)

    original_title = @shared_wish.title
    original_description = @shared_wish.description
    original_donor_conn_ids = @shared_wish.donor_connections.collect(&:id)
    original_donee_conn_ids = @shared_wish.donee_connections.collect(&:id)

    assert_includes original_donor_conn_ids, bart_to_homer_conn.id
    assert_not_includes original_donor_conn_ids, bart_to_marge_conn.id
    assert_not_includes original_donee_conn_ids, bart_to_maggie_conn.id

    new_title = 'Much better title'
    new_description = 'something for me and my dad'
    edit_wish_hash = { title: new_title,
                       description: new_description,
                       donee_conn_ids: [bart_to_maggie_conn.id],
                       donor_conn_ids: [bart_to_marge_conn.id] }

    patch :update, params: { user_id: @bart.id, id: @shared_wish.id, wish: edit_wish_hash }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@bart, @shared_wish)
    assert_equal "Seznam potenciálních dárců pro '#{original_title}' byl úspěšně aktualizován.", flash[:notice]

    @shared_wish.reload

    # wish atributes, forbidden to donee, are not changed
    assert_equal original_title, @shared_wish.title
    assert_equal original_description, @shared_wish.description
    assert_equal original_donee_conn_ids.sort, @shared_wish.donee_connections.collect(&:id).sort

    # but donors are added
    updated_donor_conn_ids = original_donor_conn_ids + [bart_to_marge_conn.id] - [bart_to_homer_conn.id]
    assert_equal updated_donor_conn_ids.sort, @shared_wish.donor_connections.collect(&:id).sort
  end

  # DELETE should not delete shared wish, but only delete user as donee
  def test_destroy
    delete :destroy, params: { user_id: @bart.id, id: @shared_wish.id }

    assert_response :redirect
    assert_redirected_to user_my_wishes_path(@bart)
    assert_equal "Byli jste odebráni z obdarovaných u přání '#{@shared_wish.title}'.", flash[:notice]

    refute Wish.where(id: @shared_wish.id).blank?
    refute @bart.donee_wishes.include?(@shared_wish)
  end

  def test_destroy_js
    delete :destroy, params: { user_id: @bart.id, id: @shared_wish.id, format: :js }

    assert_response :ok
    assert_template 'fulfilled_or_destroyed.js.erb'
    assert_equal "Byli jste odebráni z obdarovaných u přání '#{@shared_wish.title}'.", flash[:notice]

    refute Wish.where(id: @shared_wish.id).blank?
    refute @bart.donee_wishes.include?(@shared_wish)
  end

  def test_cannot_update_wish_if_is_not_donee
    nonshared_wish = wishes(:marge_homer_holidays)

    patch :update, params: { user_id: @bart.id, id: nonshared_wish.id }

    assert_response :not_found
  end

  # user cannot see wish as donee if his/her is not between donees
  def test_cannot_see_donee_wish_if_is_not_donee
    nonshared_wish = wishes(:lisa_guitar)

    get :show, params: { user_id: @bart.id, id: nonshared_wish.id }

    assert_response :not_found
  end

  def test_cannot_see_my_wishes_for_other_user_account
    get :index, params: { user_id: users(:lisa).id }

    assert_response :redirect
    assert_redirected_to user_my_wishes_url(@bart)
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_fulfilled
    patch :update, params: { user_id: @bart.id, id: @shared_wish.id, state_action: :fulfilled }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@bart, @shared_wish)
    assert_equal "Přání '#{@shared_wish.title}' bylo splněno.", flash[:notice]

    @shared_wish.reload
    assert @shared_wish.fulfilled?
  end

  def test_fulfilled_js
    patch :update, params: { user_id: @bart.id, id: @shared_wish.id, state_action: :fulfilled, format: :js }

    assert_response :ok
    assert_template 'fulfilled_or_destroyed.js.erb'
    assert_equal "Přání '#{@shared_wish.title}' bylo splněno.", flash[:notice]

    @shared_wish.reload
    assert @shared_wish.fulfilled?
  end

  def test_no_other_state_action_than_fulfilled
    other_actions = %i[book unbook call_for_co_donors withdrauthor_wish_call gifted]
    orig_updated_at = @shared_wish.updated_at.to_s
    sleep 1.second

    other_actions.each do |action|
      patch :update, params: { user_id: @bart.id, id: @shared_wish.id, state_action: action }

      @shared_wish.reload
      assert_equal orig_updated_at, @shared_wish.updated_at.to_s, "For action '#{action}' wish was changed! #{orig_updated_at} => #{@shared_wish.updated_at}"
    end
  end
end
