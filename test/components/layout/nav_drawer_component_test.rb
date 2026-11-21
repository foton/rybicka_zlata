# frozen_string_literal: true

require 'test_helper'

module Layout
  class NavDrawerComponentTest < ViewComponent::TestCase
    def setup
      @user = users(:bart)
    end

    def test_renders_destinations_and_sign_out
      render_drawer(current_path: '/')

      assert_selector 'nav#main_menu[popover] .rz-nav-drawer__item', minimum: 6
      assert_selector 'form button', text: I18n.t('devise.sessions.destroy.sign_out')
      assert_selector 'form input[name="_method"][value="delete"]', visible: :all
      assert_no_selector '[aria-current="page"]'
    end

    def test_marks_current_destination_including_nested_paths
      path = Rails.application.routes.url_helpers.user_connections_path(@user)
      render_drawer(current_path: "#{path}/123/edit")

      assert_selector 'a.is-active[aria-current="page"]', text: I18n.t('connections.views.header')
      assert_selector 'a.is-active', count: 1
    end

    def test_shows_unopened_notifications_badge
      render_drawer(current_path: '/', unopened_notifications_count: 5)

      assert_selector '.rz-nav-drawer__badge', text: '5'
    end

    private

    def render_drawer(**)
      with_request_url('/') { render_inline(NavDrawerComponent.new(user: @user, **)) }
    end
  end
end
