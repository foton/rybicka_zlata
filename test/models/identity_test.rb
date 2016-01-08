require 'test_helper'
require "minitest/mock"

class UserIdentityTest < ActiveSupport::TestCase

  #stubbing extractors
  Extractor = Struct.new(:name, :verified_email, :locale, :auth_data)

  def setup
    @user_name="John Doe"
    @user_email="john.doe@nowhere.com"

    @auth=OmniAuth::AuthHash.new( provider: "xxx", uid: "yyy")
    
    #mocking additional data from OmniAuth hash
    @extractor_verified=Extractor.new("John Doe", "john.doe@nowhere.com", "en")
    @extractor_non_verified=Extractor.new("John Doe", nil, "en")
  end

  def test_can_be_created_from_auth_without_user
    #no user given
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data

      #auth_data are not stored in DB, but transfered from search
      persisted_i=User::Identity.find_for_auth(@auth) 
      assert_equal persisted_i , i
      assert_nil persisted_i.user
      assert_equal @auth, persisted_i.auth_data
    end
  end  

  def test_can_be_created_from_auth_with_user
    cur_user=create_test_user!()
       
    User::Identity.stub(:extractor_for, @extractor_verified) do    
      i=User::Identity.create_from_auth!(@auth, cur_user)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal cur_user, i.user
    end
  end  

  def test_can_associate_user_according_to_email
 #   @auth=OmniAuth::AuthHash.new( provider: "xxx", uid: "yyy", email: "jonh.doe@example.com")
    cur_user=create_test_user!(email:  @extractor_verified.verified_email)

    #no user given    
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal cur_user, i.user
    end  
  end 

  def test_can_associate_user_according_to_email_from_another_identity
#    @auth=OmniAuth::AuthHash.new( provider: "google", uid: "yyy", email: "jonh.doe.identity@example.com")
    cur_user=create_test_user!(email: @extractor_verified.verified_email)
    User::Identity.stub(:extractor_for, @extractor_verified) do
      User::Identity.create_from_auth!(@auth.merge(provider: "ddd", uid: "sss"), cur_user) #create first identity
          
      #no user given, second identity should find it by email in first   
      i=User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal cur_user, i.user
    end  
  end 

  def test_get_verified_email
    User::Identity.stub(:extractor_for, @extractor_non_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert_nil i.verified_email
    end

    User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert_equal @user_email, i.verified_email
    end
  end  

  def test_get_temp_email
      User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert_equal "#{User::TEMP_EMAIL_PREFIX}-#{i.uid}-#{i.provider}.com", i.temp_email
    end  
  end

  def test_get_name
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert_equal @user_name, i.name
    end  
  end  

  def test_get_correct_extractors
    assert_equal User::Identity::Extractor::Google, User::Identity.extractor_for("google").class
    # ... and more comming ...
  end

end
