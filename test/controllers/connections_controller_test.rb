require 'test_helper'

class ConnectionsControllerTest < ActionController::TestCase
	include Devise::TestHelpers

  def setup
	  @request.env["devise.mapping"] = Devise.mappings[:admin]
	  @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
	  @current_user.confirm
	  sign_in @current_user
	end

  def test_index
    Connection.create!(owner: @current_user, name: "One", email: "connection@my.one")
    Connection.create!(owner: @current_user, name: "second", email: "connection@my.two")

  	get :index, {user_id: @current_user.id}

    assert assigns(:connections).present?
  	assert_equal @current_user.connections, assigns(:connections)
    assert_template "index"
    
    assert assigns(:connection).present?
    assert_not_nil assigns(:user)
    assert assigns(:connection).kind_of?(Connection)
  end 	

  def test_created
    conn_h= { name: "Ježuraa", email:"jezura@com.com"}
    
    post :create, {user_id: @current_user.id, connection: conn_h}

    assert_response :redirect
    assert_redirected_to user_connections_path(@current_user)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' byl úspěšně přidán.", flash[:notice]
  end

  def test_not_created
    conn_h= { name: "Ježuraa", email:"jezura_at_com.com"}
    
    post :create, {user_id: @current_user.id, connection: conn_h}

    assert_response :success
    assert_template "index"
    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert (assigns(:connection).errors[:email].size > 0)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' nebyl přidán.", flash[:error]
  end

  def test_edit
    connection=Connection.create!(owner: @current_user, name: "second", email: "connection@my.two")

    get :edit, {user_id: @current_user.id, id: connection.id}

    assert_response :success
    assert_template "edit"
    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert (assigns(:connection).errors.empty?)
    assert_equal connection, assigns(:connection)
  end

  def test_update
    conn_h= { name: "Ježuraa", email:"jezura@com.com"}
    connection=Connection.create!(owner: @current_user, name: "second", email: "connection@my.two")
    
    patch :update, {user_id: @current_user.id, id: connection.id, connection: conn_h}

    assert_response :redirect
    assert_redirected_to user_connections_path(@current_user)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' byl úspěšně aktualizován.", flash[:notice]
  end  

  def test_not_update
    conn_h= { name: "Ježuraa", email:"jezura_at_com.com"}
    connection=Connection.create!(owner: @current_user, name: "second", email: "connection@my.two")

    patch :update, {user_id: @current_user.id,  id: connection.id, connection: conn_h}

    assert_response :success
    assert_template "edit"
    assert_not_nil assigns(:connection)
    assert_not_nil assigns(:user)
    assert (assigns(:connection).errors[:email].size > 0)
    assert_equal "Kontakt '#{conn_h[:name]} [???]: #{conn_h[:email]}' nebyl aktualizován.", flash[:error]
  end  

  def test_destroy
    connection=Connection.create!(owner: @current_user, name: "second", email: "connection@my.two")

    delete :destroy, {user_id: @current_user.id, id: connection.id}

    assert_response :redirect
    assert_redirected_to user_connections_path(@current_user)
    assert_equal "Kontakt '#{connection.fullname}' byl úspěšně smazán.", flash[:notice]
    assert Connection.where(id: connection.id).blank?
  end

end