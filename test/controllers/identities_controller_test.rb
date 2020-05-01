# frozen_string_literal: true

require 'test_helper'

class Users::IdentitiesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @bart = users(:bart)
    sign_in @bart

    @new_email = 'new_mail@rybickazlata.cz'
  end

  def test_cannot_create_identities_for_other_user_account
    idnt_params = { email: @new_email, provider: User::Identity::LOCAL_PROVIDER }

    post :create, params: { user_id: users(:lisa).id, user_identity_as_contact: idnt_params }

    assert_response :redirect
    assert_redirected_to my_profile_path
    assert_equal 'Nakukování k sousedům není dovoleno!', flash[:error]
  end

  def test_identities_are_created_for_current_user_only
    cu_ids_count = @bart.identities.count
    assert_difference('User::Identity.count') do
      post :create, params: { user_id: @bart.id, user_identity_as_contact: { email: @new_email, provider: User::Identity::LOCAL_PROVIDER } }
    end

    assert_response :redirect
    assert_redirected_to my_profile_path
    assert_equal "Kontakt '#{@new_email}' byl přidán", flash[:notice]
    assert_equal cu_ids_count + 1, @bart.identities.count
  end

  def test_convert_to_local_identity
    assert_difference('User::Identity.count') do
      post :create, params: { user_id: @bart.id, user_identity_as_contact: { email: @new_email, provider: 'test' } }
    end

    assert_response :redirect
    assert_redirected_to my_profile_path
    # assert_not_nil assigns(:new_contact)
    assert_equal "Kontakt '#{@new_email}' byl přidán", flash[:notice]
  end

  def test_not_create_local_identity_without_valid_email
    assert_no_difference('User::Identity.count') do
      post :create, params: { user_id: @bart.id, user_identity_as_contact: { email: '', provider: User::Identity::LOCAL_PROVIDER } }
    end

    assert_response :success
    assert_template 'profiles/show'
    assert_not_nil assigns(:new_contact)
    assert_not_nil assigns(:user)
    assert !assigns(:new_contact).errors[:email].empty?
  end

  def test_cannot_delete_others_identity
    identity = identities(:lisa_identity)

    assert_no_difference('User::Identity.count') do
      delete :destroy, params: { user_id: @bart.id, id: identity.id }
    end

    assert_response :not_found # no warnings, just "we do not found it between YOUR identities"
  end

  def test_can_delete_own_identity
    identity = identities(:bart_identity_2)
    assert_difference('User::Identity.count', -1) do
      delete :destroy, params: { user_id: @bart.id, id: identity.id }
    end

    assert_response :redirect
    assert_redirected_to my_profile_path
    # assert_not_nil assigns(:new_contact)
    assert_equal "Kontakt '#{identity.displayed_name}' byl smazán", flash[:notice]
  end
end
