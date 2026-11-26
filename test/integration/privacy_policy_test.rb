# frozen_string_literal: true

require 'test_helper'

class PrivacyPolicyTest < ActionDispatch::IntegrationTest
  test 'visitors can open the privacy policy from the sign-in page' do
    get new_user_session_path
    assert_select "footer a[href^='#{privacy_policy_path}']"

    get privacy_policy_path
    assert_response :success
    assert_select 'h1', 'Zásady ochrany osobních údajů'
    assert_select '#data-deletion a[href="mailto:porybny@rybickazlata.cz"]'
  end

  test 'the privacy policy is available in English' do
    get privacy_policy_path(locale: :en)
    assert_response :success
    assert_select 'h1', 'Privacy Policy'
    assert_select '#data-deletion', /including data received through Facebook Login/
  ensure
    I18n.locale = I18n.default_locale # rubocop:disable Rails/I18nLocaleAssignment
  end
end
