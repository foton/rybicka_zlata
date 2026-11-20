# frozen_string_literal: true

require 'test_helper'

class DeviseInitializerTest < ActiveSupport::TestCase
  test 'Google OAuth uses an explicit callback URI' do
    google_options = Devise.omniauth_configs.fetch(:google).options
    expected_uri = 'http://rybickazlata.localhost:3000/users/auth/google/callback'

    assert_equal expected_uri, google_options[:redirect_uri]
  end
end
