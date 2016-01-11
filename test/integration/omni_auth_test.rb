require 'test_helper'
 
class OmniAuthController < ActionDispatch::IntegrationTest
  #  include Devise::TestHelpers

  def setup
    #OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
    #OmniAuth.config.full_host = 'http://localhost:3000'
    OmniAuth.config.test_mode = true
    
    @user_name="John Doe"
  end

  def oauth_path_for(provider, params = {})
    Rails.application.routes.url_helpers.user_omniauth_authorize_path(provider,params: params) 
  end

  def oauth_callback_path_for(provider, params = {})
    Rails.application.routes.url_helpers.user_omniauth_callback_path(provider,params: params) 
  end
   
  def test_can_sign_in_with_google 
    skip("do not know how to get current user")

    # user_email="john.doe@gmail.com"
    # OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
    #   provider: 'google',
    #   uid: '123545',
    #   info: OmniAuth::AuthHash.new({ email: user_email ,  name: @user_name , image: "https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg" }),
    #   extra: OmniAuth::AuthHash.new({raw_info: OmniAuth::AuthHash.new({locale: 'cs'}) })
    # })

    # goo_user=new_session

    # assert User.find_by_email(user_email).blank?
    # assert_nil goo_user.current_user
    

    # get oauth_path_for(:google,params: {}) 

    # #after succesfull (mocked) authorization
    # assert_redirected_to oauth_callback_path_for(:google)

    # user_created=User.find_by_email(user_email)
    # assert user_created.present?
    # assert_equal user_created.name, @user_name
    # assert_equal user_created ,current_user
  end


  def new_session
    open_session do |sess|
      yield sess if block_given?
    end
  end
end

