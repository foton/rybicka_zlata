require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    #OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
    #OmniAuth.config.full_host = 'http://localhost:3000'
    OmniAuth.config.test_mode = true
    
    @user_name="John Doe"
    @user_email="john.doe@nowhere.com"
  end

  test "#displayed_name show #name if present, #email otherwise" do
    email="my@rybickazlata.cz"
    name="Karel"
    u=User.new(email: email)
    assert_equal email, u.displayed_name
    u.name=name
    assert_equal name, u.displayed_name
  end

  def test_create_user_from_google_omni_auth_data_without_verified_email
     auth = OmniAuth::AuthHash.new({
      provider: 'google',
      uid: '123545',
      info: OmniAuth::AuthHash.new({ name: @user_name , image: "https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg" }),
      extra: OmniAuth::AuthHash.new({raw_info: OmniAuth::AuthHash.new({locale: 'cs', email: @user_email, email_verified: "!true"}) })
    })

    non_verified_email="change@me-#{auth.uid}-#{auth.provider}.com"
    current_user =nil 
    
    u=User.find_or_create_from_omniauth!(auth, current_user)

    assert u.persisted?
    assert_equal non_verified_email, u.email
    assert_equal @user_name, u.name
    assert_equal auth.extra.raw_info.locale, u.locale

    i=u.identities.where(provider: :google).first
    assert i.present?
    assert_equal auth.uid, i.uid
  end

  def test_create_user_from_google_omni_auth_data_with_verified_email
   auth = OmniAuth::AuthHash.new({
    provider: 'google',
    uid: '123545',
    info: OmniAuth::AuthHash.new({ name: @user_name , image: "https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg" }),
    extra: OmniAuth::AuthHash.new({raw_info: OmniAuth::AuthHash.new({locale: 'cs', email: @user_email, email_verified: "true"}) })
  })

  non_verified_email="change@me-#{auth.uid}-#{auth.provider}.com"
  current_user =nil 

  u=User.find_or_create_from_omniauth!(auth, current_user)

  assert u.persisted?
  assert_equal @user_email, u.email
  assert_equal @user_name, u.name
  assert_equal auth.extra.raw_info.locale, u.locale

  i=u.identities.where(provider: :google).first
  assert i.present?
  assert_equal auth.uid, i.uid
  end

end
