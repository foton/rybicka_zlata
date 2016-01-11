require 'test_helper'

class Users::IdentitiesControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	def setup
	  @request.env["devise.mapping"] = Devise.mappings[:admin]
	  @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
	  @current_user.confirm
	  sign_in @current_user

		@new_email="new_mail@rybickazlata.cz"
	end

	def test_identities_are_created_for_current_user_only
		assert_no_difference('User::Identity.count') do
			post :create, {user_id: (@current_user.id+1) , user_identity: {email: @new_email, provider: User::Identity::LOCAL_PROVIDER}}
	  end			
		
		assert_response :redirect
		assert_redirected_to root_path
		#assert_not_nil assigns(:new_contact)
		assert_equal "Nejste oprávněni zobrazit si požadovanou stránku či provést požadovanou akci.", flash[:error]
	end

	def test_create_local_identity
		assert_difference('User::Identity.count', +1) do
			post :create, {user_id: @current_user.id , user_identity: {email: @new_email, provider: User::Identity::LOCAL_PROVIDER}}
	  end			
		
		assert_response :redirect
		assert_redirected_to my_page_path
		#assert_not_nil assigns(:new_contact)
		assert_equal "Kontakt '#{@new_email}' byl přidán", flash[:notice]
	end	

	def test_not_create_not_local_identity
		assert_no_difference('User::Identity.count') do
			post :create, {user_id: (@current_user.id) , user_identity: {email: @new_email, provider: "test"}}
	  end			
		
		assert_response :redirect
		assert_redirected_to root_path
		#assert_not_nil assigns(:new_contact)
		assert_equal "Nejste oprávněni zobrazit si požadovanou stránku či provést požadovanou akci.", flash[:error]
	end	

	def test_not_create_local_identity_without_valid_email
		assert_no_difference('User::Identity.count') do
			post :create, {user_id: (@current_user.id) , user_identity: {email: "", provider: User::Identity::LOCAL_PROVIDER}}
	  end			
		
		assert_response :success
		assert_template "profiles/my"
		assert_not_nil assigns(:new_contact)
		assert_not_nil assigns(:user)
		#assert_equal "Nejste oprávněni zobrazit si požadovanou stránku či provést požadovanou akci.", flash[:error]
	end	

	def test_cannot_delete_others_identity
		@identity=User::Identity.create!(email: @new_email, provider: User::Identity::LOCAL_PROVIDER)

		assert_no_difference('User::Identity.count') do
			delete :destroy, {user_id: (@current_user.id) , id: @identity.id}
	  end			
		
		assert_response :redirect
		assert_redirected_to root_path
		#assert_not_nil assigns(:new_contact)
		assert_equal "Nejste oprávněni zobrazit si požadovanou stránku či provést požadovanou akci.", flash[:error]
	end	

	def test_can_delete_own_identity
		@identity=User::Identity.create!( user_id: @current_user.id, email: @new_email, provider: User::Identity::LOCAL_PROVIDER)
		assert_difference('User::Identity.count',-1) do
			delete :destroy, {user_id: (@current_user.id) , id: @identity.id}
	  end			
		
		assert_response :redirect
		assert_redirected_to my_page_path
		#assert_not_nil assigns(:new_contact)
		assert_equal "Kontakt '#{@new_email}' byl smazán", flash[:notice]
	end	

end
