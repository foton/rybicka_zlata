# frozen_string_literal: true

require 'test_helper'

class Wishes::FromAuthorControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @bart = users(:bart)
    sign_in @bart

    @bart_to_marge_conn = connections(:bart_to_marge)
    @bart_to_homer_conn = connections(:bart_to_homer)
    @bart_to_lisa_conn = connections(:bart_to_lisa)
    @homer_to_marge_conn = connections(:homer_to_marge)

    @wish = Wish::FromAuthor.find(wishes(:bart_homer_new_car).id)
  end

  def test_get_new_for_my_wish
    get :new, params: { user_id: @bart.id }

    assert_response :ok
    assert assigns(:wish).present?
    assert_equal @bart, assigns(:wish).author
    assert_template 'new'
  end

  def test_work_on_behalf_of_other_user_account_is_forbidden
    get :new, params: { user_id: users(:lisa).id }

    assert_response :redirect
    assert_redirected_to user_my_wishes_url(@bart)
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_create_my_wish
    donor_conns = [@bart_to_marge_conn, @bart_to_lisa_conn]
    donee_conns = [@bart_to_homer_conn]
    wish_hash = { title: 'A special wish',
                  description: 'wish me luck for tomorow!',
                  donee_conn_ids: donee_conns.collect(&:id),
                  donor_conn_ids: donor_conns.collect(&:id) }

    WishCreator.stub(:call, succesfull_creator(wish_hash, @bart)) do
      post :create, params: { user_id: @bart.id, wish: wish_hash }
    end

    assert_response :redirect
    new_wish = assigns(:wish)
    assert_redirected_to user_my_wish_path(@bart, new_wish)
    assert_equal "Přání '#{wish_hash[:title]}' bylo úspěšně přidáno.", flash[:notice]
  end

  def test_edit_shared_wish_as_author_is_forbidden
    get :edit, params: { user_id: @bart.id, id: wishes(:lisa_bart_bigger_car).id }

    assert_response :not_found
  end

  def test_edit_my_wish
    get :edit, params: { user_id: @bart.id, id: @wish.id }

    assert_equal @wish, assigns(:wish)

    assert_not_nil assigns(:user_connections)
    assert_equal @bart.friend_connections, assigns(:user_connections)

    assert_not_nil assigns(:user_groups)
    assert_equal @bart.groups, assigns(:user_groups)
  end

  def test_update_my_wish_attributes_donees_and_donors
    assert_equal [@bart_to_homer_conn, @bart.base_connection].sort, @wish.donee_connections.to_a.sort
    assert_equal [@bart_to_lisa_conn, @homer_to_marge_conn].sort, @wish.donor_connections.to_a.sort

    new_title = 'Much better title'
    new_description = 'something for me and my dad'
    edit_wish_hash = { title: new_title,
                       description: new_description,
                       donee_conn_ids: [@bart_to_lisa_conn.id],
                       donor_conn_ids: [@bart_to_marge_conn.id, @bart_to_homer_conn.id] }

    patch :update, params: { user_id: @bart.id, id: @wish.id, wish: edit_wish_hash }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@bart, @wish)
    assert_equal "Přání '#{new_title}' bylo úspěšně aktualizováno.", flash[:notice]

    @wish.reload
    assert_equal new_title, @wish.title
    assert_equal new_description, @wish.description
    assert_equal [@bart_to_lisa_conn, @bart.base_connection].sort, @wish.donee_connections.to_a.sort
    # no homer_to_marge connection, Homer is no longer donee
    assert_equal [@bart_to_marge_conn, @bart_to_homer_conn].sort, @wish.donor_connections.to_a.sort
  end

  def test_fulfilled
    patch :update, params: { user_id: @bart.id, id: @wish.id, state_action: :fulfilled }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@bart, @wish)
    assert_equal "Přání '#{@wish.title}' bylo splněno.", flash[:notice]

    @wish.reload
    assert @wish.fulfilled?
  end

  def test_fulfilled_js
    patch :update, params: { user_id: @bart.id, id: @wish.id, state_action: :fulfilled, format: :js }

    assert_response :ok
    assert_template 'fulfilled_or_destroyed.js.erb'
    assert_equal "Přání '#{@wish.title}' bylo splněno.", flash[:notice]

    @wish.reload
    assert @wish.fulfilled?
  end

  def test_destroy
    delete :destroy, params: { user_id: @bart.id, id: @wish.id }

    assert_response :redirect
    assert_redirected_to user_my_wishes_path(@bart)
    assert_equal "Přání '#{@wish.title}' bylo úspěšně smazáno.", flash[:notice]

    assert Wish.where(id: @wish.id).blank?
  end

  def test_destroy_js
    delete :destroy, params: { user_id: @bart.id, id: @wish.id, format: :js }

    assert_response :ok
    assert_template 'fulfilled_or_destroyed.js.erb'
    assert_equal "Přání '#{@wish.title}' bylo úspěšně smazáno.", flash[:notice]

    assert Wish.where(id: @wish.id).blank?
  end

  def test_author_can_manage_donees
    assert_equal [@bart_to_homer_conn, @bart.base_connection].sort, @wish.donee_connections.to_a.sort
    assert_equal [@bart_to_lisa_conn, connections(:homer_to_marge)].sort, @wish.donor_connections.to_a.sort

    edit_wish_hash = { donee_conn_ids: [@bart_to_marge_conn.id], donor_conn_ids: [@bart_to_lisa_conn.id, @bart_to_homer_conn.id] } # homer to donors, marge in donees

    patch :update, params: { user_id: @bart.id, id: @wish.id, wish: edit_wish_hash }

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@bart, @wish)
    assert_equal "Přání '#{@wish.title}' bylo úspěšně aktualizováno.", flash[:notice]
    @wish.reload
    assert_equal [@bart_to_marge_conn, @bart.base_connection].sort, @wish.donee_connections.to_a.sort
    assert_equal [@bart_to_lisa_conn, @bart_to_homer_conn].sort, @wish.donor_connections.to_a.sort
  end

  def succesfull_creator(params, author)
    OpenStruct.new(success?: true, errors: [], result: Wish::FromAuthor.new(id: 5, title: params[:title], author: author))
  end
end
