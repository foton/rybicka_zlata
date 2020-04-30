# frozen_string_literal: true

require 'test_helper'

class ConnectionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = User.create!(name: 'Pepík', email: 'pepik@josef.cz', password: 'nezalezi')
    @current_user.confirm
    sign_in @current_user
  end

  def test_index
    Connection.create!(owner: @current_user, name: 'One', email: 'connection@my.one')
    Connection.create!(owner: @current_user, name: 'second', email: 'connection@my.two')

    get :index, params: { user_id: @current_user.id }

    assert_response :success
    assert_template 'index'

    assert assigns(:connections).present?
    assert_equal @current_user.friend_connections.to_a.sort, assigns(:connections).to_a.sort

    assert assigns(:connection).present?
    assert_not_nil assigns(:user)
    assert assigns(:connection).is_a?(Connection)
  end

  def test_cannot_see_connections_for_other_user_account
    other_user = create_test_user!(name: 'OtherGuy')
    get :index, params: { user_id: other_user.id }

    assert_response :redirect
    assert_redirected_to user_connections_url(@current_user)
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_created
    conn_h = { name: 'Ježuraa', email: 'jezura@com.com' }

    post :create, params: { user_id: @current_user.id, connection: conn_h }

    assert_response :redirect
    assert_redirected_to user_connections_path(@current_user)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' byl úspěšně přidán.", flash[:notice]
  end

  def test_not_created
    conn_h = { name: 'Ježuraa', email: 'jezura_at_com.com' }

    post :create, params: { user_id: @current_user.id, connection: conn_h }

    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert !assigns(:connection).errors[:email].empty?
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' nebyl přidán.", flash[:error]
  end

  def test_edit
    connection = Connection.create!(owner: @current_user, name: 'second', email: 'connection@my.two')

    get :edit, params: { user_id: @current_user.id, id: connection.id }

    assert_response :success
    assert_template 'edit'
    assert_select '#edit_connection'

    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert assigns(:connection).errors.empty?
    assert_equal connection, assigns(:connection)
  end

  def test_update
    conn_h = { name: 'Ježuraa', email: 'jezura@com.com' }
    connection = Connection.create!(owner: @current_user, name: 'second', email: 'connection@my.two')

    patch :update, params: { user_id: @current_user.id, id: connection.id, connection: conn_h }

    assert_response :redirect
    assert_redirected_to user_connections_path(@current_user)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' byl úspěšně aktualizován.", flash[:notice]
  end

  def test_not_update
    conn_h = { name: 'Ježuraa', email: 'jezura_at_com.com' }
    connection = Connection.create!(owner: @current_user, name: 'second', email: 'connection@my.two')

    patch :update, params: { user_id: @current_user.id, id: connection.id, connection: conn_h }

    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert !assigns(:connection).errors[:email].empty?
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' nebyl aktualizován.", flash[:error]
  end

  def test_destroy
    connection = Connection.create!(owner: @current_user, name: 'second', email: 'connection@my.two')

    delete :destroy, params: { user_id: @current_user.id, id: connection.id }

    assert_response :redirect
    assert_redirected_to user_connections_path(@current_user)
    assert_equal "Kontakt '#{connection.fullname}' byl úspěšně smazán.", flash[:notice]
    assert Connection.where(id: connection.id).blank?
  end
end
