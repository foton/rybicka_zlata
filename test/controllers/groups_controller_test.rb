# frozen_string_literal: true

require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = User.create!(name: 'Pepík', email: 'pepik@josef.cz', password: 'nezalezi')
    @current_user.confirm
    sign_in @current_user

    @connections = []
    @connections << Connection.create!(owner: @current_user, name: 'One', email: 'group@my.one')
    @connections << Connection.create!(owner: @current_user, name: 'second', email: 'group@my.two')
    @connections << Connection.create!(owner: @current_user, name: 'Third', email: 'group@my.three')
    @connections << Connection.create!(owner: @current_user, name: 'FourMan', email: 'group@my.four')
   end

  def test_index
    Group.create!(user: @current_user, name: 'My group 1')
    Group.create!(user: @current_user, name: 'My group 2')

    get :index, params: { user_id: @current_user.id }

    assert_response :success
    assert_template 'index'

    assert assigns(:groups).present?
    assert_equal @current_user.groups.to_a.sort, assigns(:groups).to_a.sort

    assert assigns(:group).present?
    assert_not_nil assigns(:user)
    assert assigns(:group).is_a?(Group)
  end

  def test_index_no_groups_yet
    get :index, params: { user_id: @current_user.id }

    assert_response :success
    assert_template 'index'

    assert_equal [], assigns(:groups)
    assert_equal @current_user.groups, assigns(:groups)

    assert assigns(:group).present?
    assert_not_nil assigns(:user)
    assert assigns(:group).is_a?(Group)
  end

  def test_cannot_see_groups_for_other_user_account
    other_user = create_test_user!(name: 'OtherGuy')
    get :index, params: { user_id: other_user.id }

    assert_response :redirect
    assert_redirected_to user_groups_url(@current_user)
  end

  def test_created
    grp_h = { name: 'Family' }

    post :create, params: { user_id: @current_user.id, group: grp_h }

    # redirect to edit, where connections are added

    assert_response :redirect
    assert assigns(:group).present?
    new_group = assigns(:group)
    assert_redirected_to edit_user_group_path(@current_user, new_group)

    assert_equal grp_h[:name], new_group.name
    assert new_group.persisted?

    # open edit page
    get :edit, params: { user_id: @current_user.id, id: new_group.id }
    assert_equal "Skupina '#{grp_h[:name]}' byla úspěšně přidána. Nyní ji, prosím, naplňte lidmi.", flash[:notice]
    assert_not_nil assigns(:user_connections)
    assert_equal @connections.to_a.sort, assigns(:user_connections).to_a.sort

    # after adding connections the "create process" is finished
    edit_grp_hash = { name: new_group.name, connection_ids: @connections.collect(&:id) }

    patch :update, params: { user_id: @current_user.id, id: new_group.id, group: edit_grp_hash }

    assert_response :redirect
    assert_redirected_to user_group_path(@current_user, new_group)
    assert_equal "Skupina '#{grp_h[:name]}' byla úspěšně nastavena.", flash[:notice]
    new_group.reload
    new_group.connections.reload
    assert_equal @connections.size, new_group.connections.size
  end

  def test_not_created
    grp_h = { name: '' }

    post :create, params: { user_id: @current_user.id, group: grp_h }

    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:group)
    assert_not_nil assigns(:user)
    assert !assigns(:group).errors[:name].empty?
    assert_equal "Skupina '#{grp_h[:name]}' nebyla přidána.", flash[:error]
  end

  def test_edit
    group = Group.create!(user: @current_user, name: 'My group')

    get :edit, params: { user_id: @current_user.id, id: group.id }

    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:group)
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user_connections)
    assert assigns(:group).errors.empty?
    assert_equal group, assigns(:group)
  end

  def test_update
    group = Group.create!(user: @current_user, name: 'My group')
    edit_grp_hash = { name: group.name, connection_ids: @connections.collect(&:id) }

    patch :update, params: { user_id: @current_user.id, id: group.id, group: edit_grp_hash }

    assert_response :redirect
    assert_redirected_to user_group_path(@current_user, group)
    assert_equal "Skupina '#{group.name}' byla úspěšně nastavena.", flash[:notice]
    group.reload
    group.connections.reload
    assert_equal @connections.size, group.connections.size
  end

  def test_not_update
    skip 'do not know how to test this situation'
  end

  def test_destroy
    group = Group.create!(user: @current_user, name: 'My group', connection_ids: @connections.collect(&:id))
    all_conns_count = Connection.count
    assert_equal @connections.size, group.connections.size

    delete :destroy, params: { user_id: @current_user.id, id: group.id }

    assert_response :redirect
    assert_redirected_to user_groups_path(@current_user)
    assert_equal "Skupina '#{group.name}' byla úspěšně smazána.", flash[:notice]
    assert Group.where(id: group.id).blank?
    assert_equal all_conns_count, Connection.count # no connection should be deleted
  end
end
