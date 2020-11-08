# frozen_string_literal: true

require 'test_helper'

class ConnectionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @bart = users(:bart)
    sign_in @bart
  end

  def test_index
    get :index, params: { user_id: @bart.id }

    assert_response :success
    assert_template 'index'

    assert assigns(:connections).present?
    assert_equal @bart.friend_connections.to_a.sort, assigns(:connections).to_a.sort

    assert assigns(:connection).present?
    assert_not_nil assigns(:user)
    assert assigns(:connection).is_a?(Connection)
  end

  def test_cannot_see_connections_for_other_user_account
    get :index, params: { user_id: users(:lisa).id }

    assert_response :redirect
    assert_redirected_to user_connections_url(@bart)
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_created
    conn_h = { name: 'Ježuraa', email: 'jezura@com.com' }

    post :create, params: { user_id: @bart.id, connection: conn_h }

    assert_response :redirect
    assert_redirected_to user_connections_path(@bart)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' byl úspěšně přidán.", flash[:notice]
  end

  def test_not_created
    conn_h = { name: 'Ježuraa', email: 'jezura_at_com.com' }

    post :create, params: { user_id: @bart.id, connection: conn_h }

    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert_not assigns(:connection).errors[:email].empty?
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' nebyl přidán.", flash[:error]
  end

  def test_edit
    connection = connections(:bart_to_milhouse)

    get :edit, params: { user_id: @bart.id, id: connection.id }

    assert_response :success
    assert_template 'edit'
    assert_select '#edit_connection'

    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert assigns(:connection).errors.empty?
    assert_equal connection, assigns(:connection)
  end

  def test_updated
    conn_h = { name: 'Ježuraa', email: 'jezura@com.com' }
    connection = connections(:bart_to_milhouse)

    patch :update, params: { user_id: @bart.id, id: connection.id, connection: conn_h }

    assert_response :redirect
    assert_redirected_to user_connections_path(@bart)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' byl úspěšně aktualizován.", flash[:notice]
  end

  def test_not_updated
    conn_h = { name: 'Ježuraa', email: 'jezura_at_com.com' }
    connection = connections(:bart_to_milhouse)

    patch :update, params: { user_id: @bart.id, id: connection.id, connection: conn_h }

    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert_not assigns(:connection).errors[:email].empty?
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' nebyl aktualizován.", flash[:error]
  end

  def test_destroyed
    connection = connections(:bart_to_milhouse)

    delete :destroy, params: { user_id: @bart.id, id: connection.id }

    assert_response :redirect
    assert_redirected_to user_connections_path(@bart)
    assert_equal "Kontakt '#{connection.fullname}' byl úspěšně smazán.", flash[:notice]
    assert Connection.where(id: connection.id).blank?
  end
end
