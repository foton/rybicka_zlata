# frozen_string_literal: true

require 'test_helper'

# Theme switch without JS: /change_theme stores the choice in a cookie and the layout
# renders it as <html data-theme>.
class ThemeSwitchTest < ActionDispatch::IntegrationTest
  def test_follows_the_system_by_default
    get '/'
    assert_select 'html:not([data-theme])'
  end

  def test_dark_theme_is_remembered
    get '/change_theme', params: { theme: 'dark' }, headers: { 'HTTP_REFERER' => 'http://www.example.com/about' }
    assert_redirected_to 'http://www.example.com/about'
    assert_equal 'dark', cookies[:theme]

    get '/'
    assert_select 'html[data-theme="dark"]'
    assert_select 'a[data-theme-choice="dark"][aria-current="true"]'
  end

  def test_system_removes_the_choice_and_unknown_values_are_ignored
    get '/change_theme', params: { theme: 'light' }
    get '/change_theme', params: { theme: 'system' }
    assert cookies[:theme].blank?

    cookies[:theme] = 'pink'
    get '/'
    assert_select 'html:not([data-theme])'
  end
end
