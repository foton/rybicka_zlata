# frozen_string_literal: true

require 'test_helper'

module Layout
  class ThemeMenuComponentTest < ViewComponent::TestCase
    def test_system_is_selected_without_a_theme
      with_request_url('/') { render_inline(ThemeMenuComponent.new(theme: nil)) }

      assert_selector '#theme-switcher[popovertarget="theme-menu"] .rz-icon', 
text: 'brightness_auto'
      assert_selector '#theme-menu[popover] a.rz-theme-choice', count: 3
      assert_selector 'a[data-theme-choice="system"][aria-current="true"]', text: 'Podle systému'
      assert_selector 'a[aria-current]', count: 1
    end

    def test_chosen_theme_is_selected_and_links_work_without_js
      with_request_url('/') { render_inline(ThemeMenuComponent.new(theme: 'dark')) }

      assert_selector '#theme-switcher .rz-icon', text: 'dark_mode'
      link = page.find('a[data-theme-choice="dark"][aria-current="true"]')
      assert_match %r{/change_theme\?.*theme=dark}, link[:href]
    end
  end
end
