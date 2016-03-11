require 'test_helper'
require 'omni_auth_helper'

class Users::OmniAuthControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
 #    @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
#    @current_user.confirm
    #sign_in @current_user
  end  


  User::Identity::OAUTH_PROVIDERS.each do |provider|
  
    define_method("test_#{provider}_registration") do 
      provider_oauth_registration_test(provider)  
    end

    define_method("test_#{provider}_sign_in") do 
      provider_oauth_sign_in_test(provider)  
    end

  end  

  private

    def provider_oauth_registration_test(provider)
      assert_nil @controller.current_user
      auth_data=send("#{provider}_oauth_hash")
      assert User::Identity.where(provider: provider).where(email: auth_data.info.email).blank?
      assert User.where(email: auth_data.info.email).blank?

      provider_oauth_test(provider, auth_data)
    end  

    def provider_oauth_sign_in_test(provider)
      assert_nil @controller.current_user
      auth_data=send("#{provider}_oauth_hash")
      assert User::Identity.where(provider: provider).where(email: auth_data.info.email).blank?
      assert User.where(email: auth_data.info.email).blank?

      user=create_test_user!(name: "Johny", email: "johny@oauth.com" )
      User::Identity.create!(user: user, provider: auth_data.provider, uid: auth_data.uid)

      provider_oauth_test(provider, auth_data)
    end  

    


    def provider_oauth_test(provider, auth_data)
      @request.env["omniauth.auth"] = auth_data
  
      get provider

      assert_response 302
      assert_redirected_to my_profile_url
      assert assigns(:user).present?
      assert assigns(:user).persisted?
      user=assigns(:user)
      assert_equal @controller.current_user, user

      assert auth_data.info.email, user.email
      assert auth_data.info.email, user.identities.where(provider: provider).first.email
    end 

end  
