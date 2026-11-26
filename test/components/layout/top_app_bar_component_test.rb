# frozen_string_literal: true

require 'test_helper'

module Layout
  class TopAppBarComponentTest < ViewComponent::TestCase
    def test_signed_out_shows_sign_in_navigation
      with_request_url('/') { render_inline(TopAppBarComponent.new(user: nil)) }

      assert_selector 'nav#main_menu a', text: I18n.t('devise.sessions.new.sign_in')
      assert_selector 'nav#main_menu a', text: I18n.t('devise.registrations.new.sign_up')
      assert_no_selector '[popovertarget="main_menu"]'
      assert_selector '#locale-menu[popover] a', count: 2
      assert_no_button I18n.t('devise.sessions.destroy.sign_out')
    end

    def test_signed_in_shows_menu_toggle_and_notification_badge
      user = users(:bart)
      with_request_url('/') do
        render_inline(TopAppBarComponent.new(user: user, unopened_notifications_count: 3))
      end

      assert_selector 'button[popovertarget="main_menu"]'
      assert_no_selector 'nav#main_menu'
      assert_selector '.rz-top-app-bar__notifications .rz-badge', text: '3'
      sign_out_form = '#locale-menu + form[method="post"]'
      assert_selector "#{sign_out_form} input[name='_method'][value='delete']", visible: :all
      assert_button I18n.t('devise.sessions.destroy.sign_out'), class: 'rz-icon-button'
    end
  end
end
