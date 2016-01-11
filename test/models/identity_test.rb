require 'test_helper'
require "minitest/mock"

class UserIdentityTest < ActiveSupport::TestCase

  #stubbing extractors
  Extractor = Struct.new(:name, :verified_email, :locale, :time_zone, :auth_data,)

  def setup
    @user_name="John Doe"
    @user_email="john.doe@nowhere.com"

    @auth=OmniAuth::AuthHash.new({provider: "test", uid: "yyy", info: OmniAuth::AuthHash.new({email: @user_email}) })
    
    #mocking additional data from OmniAuth hash
    @extractor_verified=Extractor.new("John Doe", "john.doe@nowhere.com", "en","Chicago")
    @extractor_non_verified=Extractor.new("John Doe", nil, "en","London")
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
    cur_user=create_test_user!(email: @extractor_verified.verified_email)
    User::Identity.stub(:extractor_for, @extractor_verified) do
      User::Identity.create_from_auth!(@auth.merge(provider: "test", uid: "sss"), cur_user) #create first identity
          
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
      #new uid needed because one Identity with @auth.uid and @auth.provider was already created
      i=User::Identity.create_from_auth!(@auth.merge(OmniAuth::AuthHash.new(uid: "zzzz")) )
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

  def test_get_locale
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert_equal @extractor_verified.locale, i.locale
    end  
  end 

  def test_get_time_zone
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert_equal @extractor_verified.time_zone, i.time_zone
    end  
  end 

  def test_get_correct_extractors
    User::Identity::OAUTH_PROVIDERS.each do |provider|
      assert_equal "User::Identity::Extractor::#{provider.to_s.capitalize}".constantize, User::Identity.extractor_for(provider.to_s).class
    end
  end
  
  def test_recognize_local_provider
    assert User::Identity.new(provider: User::Identity::LOCAL_PROVIDER).local?
    assert !User::Identity.new(provider: "xxx").local?
  end  

  def test_cannot_have_invalid_email
    refute User::Identity.new(email: "email_@invalid").valid?
  end
    
  def test_local_identity_must_have_email
    refute User::Identity.new(email: nil, provider: User::Identity::LOCAL_PROVIDER).valid?
    assert User::Identity.new(email: "me@home.at", provider: User::Identity::LOCAL_PROVIDER).valid?
  end  

  def test_non_local_identity_can_be_without_email
    assert User::Identity.new(email: nil, provider: "google", uid: "yyyyy").valid?
  end  

  def test_can_accept_only_allowed_providers
    refute User::Identity.new(email: nil, provider: "xxx", uid: "yyyy").valid?
  end  
  
end
