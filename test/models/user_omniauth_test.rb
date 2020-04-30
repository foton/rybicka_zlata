# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
    # OmniAuth.config.full_host = 'http://localhost:3000'
    OmniAuth.config.test_mode = true

    @user_name = 'John Doe'
    @user_email = 'john.doe@nowhere.com'
  end

  def test_create_user_from_google_without_email
    auth = OmniAuth::AuthHash.new(provider: 'google',
                                  uid: '123545',
                                  info: OmniAuth::AuthHash.new(name: @user_name, email: nil, image: 'https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg'),
                                  extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(locale: 'cs', email: nil, email_verified: '!true')))

    non_verified_email = "change@me-#{auth.uid}-#{auth.provider}.com"
    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal non_verified_email, user.email
    assert_equal @user_name, user.name
    assert_equal auth.extra.raw_info.locale, user.locale

    i = user.identities.where(provider: :google).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_nil i.email
  end

  def test_create_user_from_google_without_verified_email
    nv_user_email = 'not_verified@gmail.com'
    auth = OmniAuth::AuthHash.new(provider: 'google',
                                  uid: '123545',
                                  info: OmniAuth::AuthHash.new(name: @user_name, email: nv_user_email, image: 'https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg'),
                                  extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(locale: 'cs', email: @user_email, email_verified: '!true')))

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal nv_user_email, user.email
    assert_equal @user_name, user.name
    assert_equal auth.extra.raw_info.locale, user.locale

    i = user.identities.where(provider: :google).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_equal nv_user_email, i.email
  end

  def test_create_user_from_google_with_verified_email
    auth = OmniAuth::AuthHash.new(provider: 'google',
                                  uid: '123545',
                                  info: OmniAuth::AuthHash.new(name: @user_name, email: @user_email, image: 'https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg'),
                                  extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(locale: 'cs', email: @user_email, email_verified: 'true')))

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal @user_email, user.email
    assert_equal @user_name, user.name
    assert_equal auth.extra.raw_info.locale, user.locale

    i = user.identities.where(provider: :google).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_equal @user_email, i.email
  end

  def test_create_user_from_github
    auth = OmniAuth::AuthHash.new(provider: 'github', uid: '123456',
                                  info: OmniAuth::AuthHash.new(email: @user_email,
                                                               name: 'John Doe',
                                                               nickname: 'John_doe',
                                                               image: 'https://avatars.githubusercontent.com/u/483873?v=3'))

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal @user_email, user.email
    assert_equal @user_name, user.name
    assert_equal User.new.locale, user.locale

    i = user.identities.where(provider: :github).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_equal @user_email, i.email
  end

  def test_create_user_from_facebook_without_verified_email
    nv_user_email = 'not_verified@facebook.com'
    auth = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456',
                                  info: OmniAuth::AuthHash.new(email: nv_user_email, name: @user_name),
                                  extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(email: nv_user_email, locale: 'cs_CZ', name: @user_name, timezone: -3, verified: '!true')))

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal nv_user_email, user.email
    assert_equal @user_name, user.name
    assert_equal auth.extra.raw_info.locale.split('_').first, user.locale
    # timezone -3 hours from UTC is assigned to
    assert_equal 'Brasilia', user.time_zone

    i = user.identities.where(provider: :facebook).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_equal nv_user_email, i.email
  end

  def test_create_user_from_facebook_with_verified_email
    auth = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456',
                                  info: OmniAuth::AuthHash.new(email: @user_email, name: @user_name),
                                  extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(email: @user_email, locale: 'en_GB', name: @user_name, timezone: -3, verified: 'true')))

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal @user_email, user.email
    assert_equal @user_name, user.name
    assert_equal auth.extra.raw_info.locale.split('_').first, user.locale
    # timezone -3 hours from UTC is assigned to
    assert_equal 'Brasilia', user.time_zone

    i = user.identities.where(provider: :facebook).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_equal @user_email, i.email
  end

  def test_create_user_from_twitter_without_email
    # twitter do not serve email of user
    auth = OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456',
                                  info: OmniAuth::AuthHash.new(name: @user_name, nickname: 'Johnny'),
                                  extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(lang: 'cs', name: @user_name, time_zone: 'Chicago', verified: '!true')))

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    # assert_equal nv_user_email, user.email
    assert_equal @user_name, user.name
    assert_equal auth.extra.raw_info.lang, user.locale
    # timezone -3 hours from UTC is assigned to
    assert_equal auth.extra.raw_info.time_zone, user.time_zone

    i = user.identities.where(provider: :twitter).first
    assert i.present?
    assert_equal auth.uid, i.uid
    # assert_equal nv_user_email, i.email
  end

  # def test_create_user_from_linkedin
  #   auth = OmniAuth::AuthHash.new(provider: 'linkedin', uid: '123456',
  #                                 info: OmniAuth::AuthHash.new(email: @user_email,
  #                                                              name: @user_name,
  #                                                              nickname: 'John_doe',
  #                                                              image: 'https://media.licdn.com/mpr/mprx/0_fDcXEjwcCo3FeyuXDfXBEYedCHnoeyuXS7iUEYWcgDCVB4Uk_IFHXOjJuQ9zIUSHaazV5JUgVJ65'))

  #   current_user = nil

  #   user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

  #   assert user.persisted?
  #   assert_equal @user_email, user.email
  #   assert_equal @user_name, user.name
  #   assert_equal User.new.locale, user.locale

  #   i = user.identities.where(provider: :linkedin).first
  #   assert i.present?
  #   assert_equal auth.uid, i.uid
  #   assert_equal @user_email, i.email
  # end

  def test_merge_identity_with_existing_user_according_to_user_main_email
    auth = OmniAuth::AuthHash.new(provider: 'github', uid: '123456',
                                  info: OmniAuth::AuthHash.new(email: @user_email,
                                                               name: 'John Doe',
                                                               nickname: 'John_doe',
                                                               image: 'https://avatars.githubusercontent.com/u/483873?v=3'))
    orig_user_name = 'Original John Doe'
    orig_user = create_test_user!(name: orig_user_name, email: @user_email)
    idnt_count = orig_user.identities.count

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal orig_user, user
    assert_equal (idnt_count + 1), orig_user.identities.count, orig_user.identities.to_yaml

    i = orig_user.identities.where(provider: :github).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_equal @user_email, i.email
  end

  def test_merge_identity_with_existing_user_according_to_user_email_from_other_identity
    auth = OmniAuth::AuthHash.new(provider: 'github', uid: '123456',
                                  info: OmniAuth::AuthHash.new(email: @user_email,
                                                               name: 'John Doe',
                                                               nickname: 'John_doe',
                                                               image: 'https://avatars.githubusercontent.com/u/483873?v=3'))
    orig_user_name = 'Original John Doe'
    orig_user = create_test_user!(name: orig_user_name, email: 'no' + @user_email)

    User::Identity.create!(email: @user_email, provider: User::Identity::LOCAL_PROVIDER, user: orig_user)
    idnt_count = orig_user.identities.count

    current_user = nil

    user, _passwd = User.find_or_create_from_omniauth!(auth, current_user)

    assert user.persisted?
    assert_equal orig_user, user
    assert_equal (idnt_count + 1), orig_user.identities.count, orig_user.identities.to_yaml

    i = orig_user.identities.where(provider: :github).first
    assert i.present?
    assert_equal auth.uid, i.uid
    assert_equal @user_email, i.email
  end
end
