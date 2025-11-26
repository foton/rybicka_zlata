# frozen_string_literal: true

require 'test_helper'

# Make sure that https://nvd.nist.gov/vuln/detail/CVE-2015-9284 is mitigated
class OmniauthCsrfTest < ActionDispatch::IntegrationTest
  setup do
    ActionController::Base.allow_forgery_protection = true
    OmniAuth.config.test_mode = false
    @oauth_path = Rails.application.routes.url_helpers.user_google_omniauth_authorize_path
  end

  test 'should not accept GET requests to OmniAuth endpoint' do
    get @oauth_path
    assert_response :missing
  end

  test 'should not accept POST requests with invalid CSRF tokens to OmniAuth endpoint' do
    post @oauth_path

    assert_response :unprocessable_entity
    assert_includes response.body, "Can't verify CSRF token authenticity"
  end

  teardown do
    ActionController::Base.allow_forgery_protection = false
    OmniAuth.config.test_mode = true
  end
end
