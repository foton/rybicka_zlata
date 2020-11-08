# frozen_string_literal: true

require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @bart = users(:bart)
    sign_in @bart
  end

  def test_index
    group = groups(:bart_family)

    get :index, params: { user_id: @bart.id }

    assert_response :success
    assert_template 'index'

    assert assigns(:groups).present?
    assert_equal @bart.groups.to_a.sort, assigns(:groups).to_a.sort

    assert assigns(:group).present?
    assert_not_nil assigns(:user)
    assert assigns(:group).is_a?(Group)
  end

  def test_index_no_groups_yet
    groups(:bart_family).destroy!

    get :index, params: { user_id: @bart.id }

    assert_response :success
    assert_template 'index'

    assert_equal [], assigns(:groups)
    assert_equal @bart.groups, assigns(:groups)

    assert assigns(:group).present?
    assert_not_nil assigns(:user)
    assert assigns(:group).is_a?(Group)
  end

  def test_cannot_see_groups_for_other_user_account
    get :index, params: { user_id: users(:marge).id }

    assert_response :redirect
    assert_redirected_to user_groups_url(@bart)
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_created
    grp_h = { name: 'Friends' }

    post :create, params: { user_id: @bart.id, group: grp_h }

    # redirect to edit, where connections are added

    assert_response :redirect
    assert assigns(:group).present?
    new_group = assigns(:group)
    assert_redirected_to edit_user_group_path(@bart, new_group)

    assert_equal grp_h[:name], new_group.name
    assert new_group.persisted?

    # open edit page
    get :edit, params: { user_id: @bart.id, id: new_group.id }
    assert_equal "Skupina '#{grp_h[:name]}' byla úspěšně přidána. Nyní ji, prosím, naplňte lidmi.", flash[:notice]
    assert_not_nil assigns(:user_connections)
    assert_equal @bart.friend_connections.to_a.sort, assigns(:user_connections).to_a.sort

    # after adding connections the "create process" is finished
    edit_grp_hash = { name: new_group.name, connection_ids: [connections(:bart_to_milhouse).id] }

    patch :update, params: { user_id: @bart.id, id: new_group.id, group: edit_grp_hash }

    assert_response :redirect
    assert_redirected_to user_group_path(@bart, new_group)
    assert_equal "Skupina '#{grp_h[:name]}' byla úspěšně nastavena.", flash[:notice]
    new_group.connections.reload
    assert_equal [connections(:bart_to_milhouse).name], new_group.connections.collect(&:name)
  end

  def test_not_created
    grp_h = { name: '' }

    post :create, params: { user_id: @bart.id, group: grp_h }

    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:group)
    assert_not_nil assigns(:user)
    assert_not assigns(:group).errors[:name].empty?
    assert_equal "Skupina '#{grp_h[:name]}' nebyla přidána.", flash[:error]
  end

  def test_edit
    group = groups(:bart_family)

    get :edit, params: { user_id: @bart.id, id: group.id }

    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:group)
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user_connections)
    assert assigns(:group).errors.empty?
    assert_equal group, assigns(:group)
  end

  def test_update
    group = groups(:bart_family)
    connections = [connections(:bart_to_milhouse), connections(:bart_to_maggie)]
    edit_grp_hash = { name: group.name, connection_ids: connections.collect(&:id) }

    patch :update, params: { user_id: @bart.id, id: group.id, group: edit_grp_hash }

    assert_response :redirect
    assert_redirected_to user_group_path(@bart, group)
    assert_equal "Skupina '#{group.name}' byla úspěšně nastavena.", flash[:notice]
    group.reload
    group.connections.reload
    assert_equal connections.size, group.connections.size
  end

  def test_not_update
    skip 'do not know how to test this situation (connection for other user? wrong name?)'
  end

  def test_destroy
    group = groups(:bart_family)
    all_conns_count = Connection.count
    assert_equal %w[mom dad lisa].size, group.connections.size

    delete :destroy, params: { user_id: @bart.id, id: group.id }

    assert_response :redirect
    assert_redirected_to user_groups_path(@bart)
    assert_equal "Skupina '#{group.name}' byla úspěšně smazána.", flash[:notice]
    assert Group.where(id: group.id).blank?
    assert_equal all_conns_count, Connection.count # no connection should be deleted
  end
end
