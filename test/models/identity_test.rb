# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class UserIdentityTest < ActiveSupport::TestCase
  # stubbing extractors
  Extractor = Struct.new(:name, :verified_email, :email, :locale, :time_zone, :auth_data)

  def setup
    @user_name = 'John Doe'
    @user_email = 'john.doe@nowhere.com'
    @user = create_test_user!(name: @user_name, email: @user_email)

    @auth = OmniAuth::AuthHash.new(provider: 'test', uid: 'yyy', info: OmniAuth::AuthHash.new(email: @user_email))

    # mocking additional data from OmniAuth hash
    @extractor_verified = Extractor.new(@user_name, @user_email, @user_email, 'en', 'Chicago')
    @extractor_non_verified = Extractor.new(@user_name, nil, @user_email, 'en', 'London')
  end

  def test_can_be_created_from_auth_without_user
    # no user given
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i = User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data

      # auth_data are not stored in DB, but transfered from search
      persisted_i = User::Identity.find_for_auth(@auth)
      assert_equal persisted_i, i
      assert_equal @user, persisted_i.user
      assert_equal @auth, persisted_i.auth_data
    end
  end

  def test_can_be_created_from_auth_with_user
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i = User::Identity.create_from_auth!(@auth, @user)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal @user, i.user
    end
  end

  def test_can_associate_user_according_to_email
    # no user given
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i = User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal @user, i.user
    end
  end

  def test_can_associate_user_according_to_email_from_another_identity
    User::Identity.stub(:extractor_for, @extractor_verified) do
      User::Identity.create_from_auth!(@auth.merge(provider: 'test', uid: 'sss'), @user) # create first identity

      # no user given, second identity should find it by email in first one
      i = User::Identity.create_from_auth!(@auth)
      assert i.persisted?
      assert_equal @auth, i.auth_data
      assert_equal @user, i.user
    end
  end

  def test_get_verified_email
    User::Identity.stub(:extractor_for, @extractor_non_verified) do
      i = User::Identity.create_from_auth!(@auth)
      assert_nil i.verified_email
    end

    User::Identity.stub(:extractor_for, @extractor_verified) do
      # new uid needed because one Identity with @auth.uid and @auth.provider was already created
      i = User::Identity.create_from_auth!(@auth.merge(OmniAuth::AuthHash.new(uid: 'zzzz')))
      assert_equal @user_email, i.verified_email
    end
  end

  def test_get_temp_email
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i = User::Identity.create_from_auth!(@auth)
      assert_equal "#{User::TEMP_EMAIL_PREFIX}-#{i.uid}-#{i.provider}.com", i.temp_email
    end
  end

  def test_get_name
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i = User::Identity.create_from_auth!(@auth)
      assert_equal @user_name, i.name
    end
  end

  def test_get_locale
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i = User::Identity.create_from_auth!(@auth)
      assert_equal @extractor_verified.locale, i.locale
    end
  end

  def test_get_time_zone
    User::Identity.stub(:extractor_for, @extractor_verified) do
      i = User::Identity.create_from_auth!(@auth)
      assert_equal @extractor_verified.time_zone, i.time_zone
    end
  end

  def test_get_correct_extractors
    User::Identity::OAUTH_PROVIDERS.each do |provider|
      assert_equal "User::Identity::Extractor::#{provider.to_s.capitalize}".constantize,
                   User::Identity.extractor_for(provider.to_s).class
    end
  end

  def test_recognize_local_provider
    assert User::Identity.new(provider: User::Identity::LOCAL_PROVIDER).local?
    assert_not User::Identity.new(provider: 'xxx').local?
  end

  def test_cannot_have_invalid_email
    assert_not User::Identity.new(email: 'email_@invalid').valid?
  end

  def test_local_identity_must_have_email
    assert_not User::Identity.new(email: nil, provider: User::Identity::LOCAL_PROVIDER, user_id: @user.id).valid?
    assert User::Identity.new(email: 'me@home.at', provider: User::Identity::LOCAL_PROVIDER, user_id: @user.id).valid?
  end

  def test_non_local_identity_can_be_without_email
    assert User::Identity.new(email: nil, provider: 'google', uid: 'yyyyy', user_id: @user.id).valid?
  end

  def test_can_accept_only_allowed_providers
    assert_not User::Identity.new(email: nil, provider: 'xxx', uid: 'yyyy').valid?
  end

  def test_user_must_be_valid
    same_email = 'common@email.cz'
    idnt1 = User::Identity.new(email: same_email,
                               provider: User::Identity::LOCAL_PROVIDER,
                               user_id: User.last.id + 1)
    assert_not idnt1.valid?
    assert ['není'], idnt1.errors[:user]
  end

  def test_one_email_cannot_belong_to_more_users
    same_email = identities(:maggie_identity).email

    idnt2 = User::Identity.new(user: users(:bart),
                               email: same_email,
                               provider: User::Identity::LOCAL_PROVIDER)
    assert_not idnt2.valid?
    assert_equal ["E-mailová adresa '#{same_email}' je již přiřazena jinému uživateli!"],
                 idnt2.errors[:email]
  end

  # not needed: def test_main_idenity_cannot_be_deleted

  #---------- FRIENDSHIP UPDATES --------

  def test_binding_user_to_connection
    marge = users(:marge)
    maggie = users(:maggie)
    maggie_new_email = 'little_maggie@example.com'
    connection = Connection.create!(name: 'The little one', email: maggie_new_email, owner: marge)

    assert_nil connection.friend, "connection.friend should be blank, but is #{connection.friend}"

    # now add identity with such email to Maggie
    idnt = User::Identity.new(email: maggie_new_email, provider: User::Identity::LOCAL_PROVIDER)
    assert maggie.identities << idnt

    # should be binded after_save
    assert_equal maggie, connection.reload.friend

    # when identity is destroyed, friend is set nil
    idnt.destroy

    assert_nil connection.reload.friend_id
  end
end
