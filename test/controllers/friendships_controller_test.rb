require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
	include Devise::TestHelpers

  def setup
	  @request.env["devise.mapping"] = Devise.mappings[:admin]
	  @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
	  @current_user.confirm
	  sign_in @current_user
	end

  def test_index
  	get :index, {user_id: @current_user.id}
    assert assigns(:friendships).present?
  	assert_equal assigns(:friendships), user_friendshipss
  end 	
end