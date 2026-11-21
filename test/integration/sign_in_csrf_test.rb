# frozen_string_literal: true

require 'test_helper'

# Sign in with forgery protection on (it is off in the test env by default).
# A failed sign in makes Devise re-run sessions#new on the same POST request; the form's
# per-form CSRF token must still be valid then (regression: ?locale=cs in the form action).
class SignInCsrfTest < ActionDispatch::IntegrationTest
  def setup
    @forgery_protection = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
  end

  def teardown
    ActionController::Base.allow_forgery_protection = @forgery_protection
    # set_locale changes it for the whole test process
    I18n.locale = I18n.default_locale # rubocop:disable Rails/I18nLocaleAssignment
  end

  def test_wrong_password_shows_the_error_at_the_form
    path, options = sign_in_request(password: 'wrong-password', locale: 'en')
    post path, **options

    assert_response :ok
    assert_select '#sign_in_alert', text: /Invalid .* or password/
    assert_select 'html[lang="en"]'
  end

  def test_right_password_signs_in
    path, options = sign_in_request(password: 'Abcd1234', locale: 'cs')
    post path, **options

    assert_redirected_to %r{/my_profile}
  end

  private

  def sign_in_request(password:, locale:)
    get "/users/sign_in?locale=#{locale}"
    form = response.parsed_body.at_css('form#new_user')
    assert_equal '/users/sign_in', form['action']

    params = { authenticity_token: form.at_css('[name=authenticity_token]')['value'],
               locale: form.at_css('[name=locale]')['value'],
               user: { email: users(:bart).email, password: password } }
    [form['action'], { params: params, env: { 'action_dispatch.show_exceptions' => :none } }]
  end
end
