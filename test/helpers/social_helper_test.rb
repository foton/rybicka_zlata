# frozen_string_literal: true

require 'test_helper'

class SocialHelperTest < ActionView::TestCase
  test 'renders current Google sign-in button' do
    button = sign_in_button_for(:google)

    assert_includes button, '>Google</span>'
    assert_not_includes button, 'Google+'
    assert_includes button, user_google_omniauth_authorize_path
  end

  test 'renders X sign-in button using the existing OAuth route' do
    button = sign_in_button_for(:twitter)

    assert_includes button, '>X</span>'
    assert_includes button, user_twitter_omniauth_authorize_path
  end
end
