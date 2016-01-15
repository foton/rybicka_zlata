require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
	include Devise::TestHelpers

  def setup
	  @request.env["devise.mapping"] = Devise.mappings[:admin]
	  @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
	  @current_user.confirm
	  sign_in @current_user
	end

  def test_my_page_is_setup_correctly
  	get :my
    assert assigns(:user).present?
  	assert_equal assigns(:user).class, User

    assert assigns(:new_contact).present?
  	assert_equal assigns(:new_contact).class, User::Identity::AsContact
  end 	
end
