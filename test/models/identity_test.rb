require 'test_helper'
require "minitest/mock"

class UserIdentityTest < ActiveSupport::TestCase

  #stubbing extractors
  Extractor = Struct.new(:name, :verified_email, :email, :locale, :time_zone, :auth_data,)

  def setup
    @user_name="John Doe"
    @user_email="john.doe@nowhere.com"
    @user=create_test_user!(name: @user_name, email: @user_email)

    @auth=OmniAuth::AuthHash.new({provider: "test", uid: "yyy", info: OmniAuth::AuthHash.new({email: @user_email}) })
    
    #mocking additional data from OmniAuth hash
    @extractor_verified=Extractor.new(@user_name, @user_email,@user_email, "en","Chicago")
    @extractor_non_verified=Extractor.new(@user_name, nil, @user_email, "en","London")
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
      assert_equal @user, persisted_i.user
      assert_equal @auth, persisted_i.auth_data
    end
  end  

  def test_can_be_created_from_auth_with_user
    User::Identity.stub(:extractor_for, @extractor_verified) do    
      i=User::Identity.create_from_auth!(@auth, @user)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal @user, i.user
    end
  end  

  def test_can_associate_user_according_to_email
    #no user given    
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i=User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal @user, i.user
    end  
  end 

  def test_can_associate_user_according_to_email_from_another_identity
    User::Identity.stub(:extractor_for, @extractor_verified) do
      User::Identity.create_from_auth!(@auth.merge(provider: "test", uid: "sss"), @user) #create first identity
          
      #no user given, second identity should find it by email in first   
      i=User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal @user, i.user
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
    refute User::Identity.new(provider: "xxx").local?
  end  

  def test_cannot_have_invalid_email
    refute User::Identity.new(email: "email_@invalid").valid?
  end
    
  def test_local_identity_must_have_email
    refute User::Identity.new(email: nil, provider: User::Identity::LOCAL_PROVIDER, user_id: @user.id).valid?
    assert User::Identity.new(email: "me@home.at", provider: User::Identity::LOCAL_PROVIDER, user_id: @user.id).valid?
  end  

  def test_non_local_identity_can_be_without_email
    assert User::Identity.new(email: nil, provider: "google", uid: "yyyyy", user_id: @user.id).valid?
  end  

  def test_can_accept_only_allowed_providers
    refute User::Identity.new(email: nil, provider: "xxx", uid: "yyyy").valid?
  end  

  def test_user_must_be_valid
    same_email="common@email.cz"
    idnt1=User::Identity.new( email: same_email, provider: User::Identity::LOCAL_PROVIDER, user_id: (User.last.id+1 rescue 1))
    refute idnt1.valid?
    assert ["není"], idnt1.errors[:user]
  end  

  def test_one_email_cannot_belong_to_more_users
    same_email="common@email.cz"
    idnt1=User::Identity.new( email: same_email, provider: User::Identity::LOCAL_PROVIDER, user_id: @user.id)
    assert idnt1.valid?
    idnt1.save!

    second_user=create_test_user!(email: "john@thesecond.com")

    idnt2=User::Identity.new( email: same_email, provider: User::Identity::LOCAL_PROVIDER, user_id: second_user.id)
    refute idnt2.valid?
    assert_equal idnt2.errors[:email], ["E-mailová adresa '#{same_email}' je již přiřazena jinému uživateli!"]
  end  

  #---------- FRIENDSHIP UPDATES --------

  def setup_connection
    @owner=create_test_user!
    @user_to=create_test_user!(name: "Ford", email: "hitchhiker@galaxy.museum")
    @connection=Connection.new(name: "Simon", email: "simon@says.com", owner_id: @owner.id)
    assert @connection.save
  end 

  def test_binding_user_to_connection
    setup_connection
    
    assert_equal nil, @connection.friend, "@connection.friend should be blank, but is #{@connection.friend}"
    #now add indentiti to @user to with email mentioned in @connection
    idnt=User::Identity.new( email: @connection.email, provider: User::Identity::LOCAL_PROVIDER)
    assert @user_to.identities << idnt
    
    #should be binded aftre_save
    @connection.reload
    assert_equal @user_to, @connection.friend

    idnt.destroy

    @connection.reload
    assert_nil @connection.friend_id
  end  

end
