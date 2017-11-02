# frozen_string_literal: true

require 'test_helper'

class Wishes::FromDoneeControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = User.create!(name: 'Pepík', email: 'pepik@josef.cz', password: 'nezalezi')
    @current_user.confirm
    sign_in @current_user

    @conn_mama = create_connection_for(@current_user, name: 'Máma')
    @conn_tata = create_connection_for(@current_user, name: 'Táta')

    @other_user = create_test_user!(name: 'OtherGuy')
    @conn_to_current_user = create_connection_for(@other_user, name: 'Pepa', email: @current_user.email)
    @conn_tata_from_other_user = create_connection_for(@other_user, name: 'Táta')
    # @conn_to_other_user=create_connection_for(@current_user, {name: "other user", email: @other_user.email})
  end

  def test_index_of_my_wishes
    aw = create_author_wish
    sw = create_shared_wish

    get :index, params: { user_id: @current_user.id }

    assert assigns(:wishes).present?
    assert_equal [sw, aw], assigns(:wishes).to_a
    assert_template 'index'
    assert_not_nil assigns(:user)
  end

  def test_index_of_my_fulfilled_wishes
    aw = create_author_wish
    aw.fulfilled!(@current_user)
    aw.save!
    sw = create_shared_wish

    get :index, params: { user_id: @current_user.id, fulfilled: 1 }

    assert assigns(:wishes).present?
    assert_equal [aw], assigns(:wishes).to_a
    assert_template 'index_fulfilled'
    assert_not_nil assigns(:user)
  end

  def test_index_of_my_notfulfilled_wishes
    aw = create_author_wish
    aw.fulfilled!(@current_user)
    aw.save!
    sw = create_shared_wish

    get :index, params: { user_id: @current_user.id }

    assert assigns(:wishes).present?
    assert_equal [sw], assigns(:wishes).to_a
    assert_template 'index'
    assert_not_nil assigns(:user)
  end

  def test_index_no_wish_yet
    # Wish.destroy_all
    assert @current_user.donee_wishes.blank?

    get :index, params: { user_id: @current_user.id }

    assert_equal [], assigns(:wishes)
    assert_template 'index'
    assert_not_nil assigns(:user)
  end

  def test_show_of_my_own_wish
    author_wish = create_author_wish

    get :show, params: { user_id: @current_user.id, id: author_wish.id }

    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).is_a?(Wish::FromDonee)
    assert_equal author_wish, assigns(:wish)
  end

  def test_show_of_shared_wish
    shared_wish = create_shared_wish

    get :show, params: { user_id: @current_user.id, id: shared_wish.id }

    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).is_a?(Wish::FromDonee)
    assert_equal shared_wish, assigns(:wish)
  end

  def test_edit_shared_wish
    shared_wish = create_shared_wish
    usr_conns = @current_user.connections - [@current_user.base_connection]
    available_donor_conns = usr_conns

    get :edit, params: { user_id: @current_user.id, id: shared_wish.id }

    assert_not_nil assigns(:wish)
    assert_equal shared_wish, assigns(:wish)

    assert_not_nil assigns(:user_connections)
    assert_equal usr_conns, assigns(:user_connections)

    assert_not_nil assigns(:user_groups)
    assert_equal @current_user.groups, assigns(:user_groups)

    assert_not_nil assigns(:available_donor_connections)
    assert_equal available_donor_conns, assigns(:available_donor_connections)
  end

  def test_add_donors_to_shared_wish
    shared_wish = create_shared_wish
    conn_segra = create_connection_for(@current_user, name: 'Ségra')
    # donee can change only donors from his connections

    new_title = 'Much better title'
    new_description = 'something for me and my dad'

    original_title = shared_wish.title
    original_description = shared_wish.description
    original_donor_conn_ids = shared_wish.donor_connections.collect(&:id)
    assert_equal [@conn_tata_from_other_user.id], original_donor_conn_ids
    original_donee_conn_ids = shared_wish.donee_connections.collect(&:id)

    edit_wish_hash = { title: new_title, description: new_description, donee_conn_ids: [@conn_tata.id] }
    edit_wish_hash[:donor_conn_ids] = [@conn_mama.id, conn_segra.id]

    patch :update, params: { user_id: @current_user.id, id: shared_wish.id, wish: edit_wish_hash }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user, shared_wish)
    assert_equal "Seznam potenciálních dárců pro '#{original_title}' byl úspěšně aktualizován.", flash[:notice]

    shared_wish.reload
    # wish atributes, forbidden to donee, are not changed
    assert_equal original_title, shared_wish.title
    assert_equal original_description, shared_wish.description
    assert_equal original_donee_conn_ids.sort, shared_wish.donee_connections.collect(&:id).sort
    # but donor are added
    assert_equal (original_donor_conn_ids + edit_wish_hash[:donor_conn_ids]).sort, shared_wish.donor_connections.collect(&:id).sort
  end

  def test_manage_own_donors_of_shared_wish
    shared_wish = create_shared_wish
    conn_segra = create_connection_for(@current_user, name: 'Ségra')
    # donee can change only donors from his connections

    # add first set of donors
    original_my_donor_conn_ids = [@conn_mama.id, @conn_tata.id]
    shared_wish.merge_donor_conn_ids(original_my_donor_conn_ids, @current_user)
    shared_wish.save!
    original_donor_conn_ids = shared_wish.donor_connections.collect(&:id)
    assert_equal ([@conn_tata_from_other_user.id] + original_my_donor_conn_ids), original_donor_conn_ids

    # tata is out, mama left and segra is added
    edit_wish_hash = { donor_conn_ids: [@conn_mama.id, conn_segra.id] }

    patch :update, params: { user_id: @current_user.id, id: shared_wish.id, wish: edit_wish_hash }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user, shared_wish)
    assert_equal "Seznam potenciálních dárců pro '#{shared_wish.title}' byl úspěšně aktualizován.", flash[:notice]

    shared_wish.reload
    new_donor_conn_ids = [@conn_tata_from_other_user.id, @conn_mama.id, conn_segra.id]
    assert_equal new_donor_conn_ids.sort, shared_wish.donor_connections.collect(&:id).sort
  end

  # DELETE should not delete wish, but only delete user as donee
  def test_destroy
    shared_wish = create_shared_wish

    delete :destroy, params: { user_id: @current_user.id, id: shared_wish.id }

    assert_response :redirect
    assert_redirected_to user_my_wishes_path(@current_user)
    assert_equal "Byli jste odebráni z obdarovaných u přání '#{shared_wish.title}'.", flash[:notice]

    refute Wish.where(id: shared_wish.id).blank?
    refute @current_user.donee_wishes.include?(shared_wish)
  end

  def test_destroy_js
    shared_wish = create_shared_wish

    delete :destroy, params: { user_id: @current_user.id, id: shared_wish.id, format: :js }

    assert_response :ok
    assert_template 'fulfilled_or_destroyed.js.erb'
    assert_equal "Byli jste odebráni z obdarovaných u přání '#{shared_wish.title}'.", flash[:notice]

    refute Wish.where(id: shared_wish.id).blank?
    refute @current_user.donee_wishes.include?(shared_wish)
  end

  def test_cannot_update_wish_if_is_not_donee
    nonshared_wish = create_nonshared_wish

    patch :update, params: { user_id: @current_user.id, id: nonshared_wish.id }

    assert_response :not_found
  end

  # user cannot see wish as donee if his/her is not between donees
  def test_cannot_see_donee_wish_if_is_not_donee
    nonshared_wish = create_nonshared_wish

    get :show, params: { user_id: @current_user.id, id: nonshared_wish.id }

    assert_response :not_found
  end

  def test_cannot_see_my_wishes_for_other_user_account
    get :index, params: { user_id: @other_user.id }

    assert_response :redirect
    assert_redirected_to user_my_wishes_url(@current_user)
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_fulfilled
    shared_wish = create_shared_wish

    patch :update, params: { user_id: @current_user.id, id: shared_wish.id, state_action: :fulfilled }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user, shared_wish)
    assert_equal "Přání '#{shared_wish.title}' bylo splněno.", flash[:notice]

    shared_wish.reload
    assert shared_wish.fulfilled?
  end

  def test_fulfilled_js
    shared_wish = create_shared_wish

    patch :update, params: { user_id: @current_user.id, id: shared_wish.id, state_action: :fulfilled, format: :js }

    assert_response :ok
    assert_template 'fulfilled_or_destroyed.js.erb'
    assert_equal "Přání '#{shared_wish.title}' bylo splněno.", flash[:notice]

    shared_wish.reload
    assert shared_wish.fulfilled?
  end

  def test_no_other_state_action_than_fulfilled
    shared_wish = create_shared_wish
    other_actions = %i[book unbook call_for_co_donors withdraw_call gifted]
    orig_updated_at = shared_wish.updated_at.to_s
    sleep 1.second

    for action in other_actions
      patch :update, params: { user_id: @current_user.id, id: shared_wish.id, state_action: action }

      shared_wish.reload
      assert_equal orig_updated_at, shared_wish.updated_at.to_s, "For action '#{action}' wish was changed! #{orig_updated_at} => #{shared_wish.updated_at}"
    end
  end

  private

  def create_author_wish
    author_wish = Wish::FromAuthor.new(author: @current_user, title: 'My first wish', description: 'This is my first wish I am trying')
    author_wish.merge_donor_conn_ids([@conn_mama.id, @conn_tata.id], @current_user)
    author_wish.save!
    author_wish = Wish::FromDonee.find(author_wish.id)
  end

  def create_shared_wish
    shared_wish = Wish::FromAuthor.new(author: @other_user, donee_conn_ids: [@conn_to_current_user.id], title: 'My shared wish', description: 'I am sharing this wish with Pepa (aka current_user)')
    shared_wish.merge_donor_conn_ids([@conn_tata_from_other_user.id], @other_user)
    shared_wish.save!
    shared_wish = Wish::FromDonee.find(shared_wish.id)
  end

  def create_nonshared_wish
    nonshared_wish = Wish::FromAuthor.new(author: @other_user, title: 'Only my wish', description: 'I am the only donee, but Pepa is between donors')
    nonshared_wish.merge_donor_conn_ids([@conn_to_current_user.id], @other_user)
    nonshared_wish.save!
    nonshared_wish
  end
end
