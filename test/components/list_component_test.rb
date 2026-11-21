# frozen_string_literal: true

require 'test_helper'

class ListComponentTest < ViewComponent::TestCase
  def setup
    prepare_wish_and_others
  end

  def test_empty_text
    render_inline(ListComponent.new(empty_text: 'Žádná přání'))

    assert_selector 'p.rz-list__empty', text: 'Žádná přání'
    assert_no_selector 'ul'
  end

  def test_row_with_actions_as_buttons_and_menu
    with_request_url('/') do
      render_inline(ListComponent.new) do |list|
        list.with_item(object: @wish, user: @donor, remote: true) { 'M+H holidays' }
      end
    end

    row = page.find("ul.rz-list li#wish_#{@wish.id}.wish_#{@wish.id}")
    assert row.has_css?('.rz-list-item__content', text: 'M+H holidays')
    assert row.has_css?('.actions .rz-list-item__buttons form[data-turbo="true"] button.book')
    assert row.has_css?('.rz-list-item__menu [popover] button.rz-menu__item.book', visible: :all)
  end

  def test_two_menus_get_own_anchors
    with_request_url('/') do
      render_inline(ListComponent.new) do |list|
        2.times { list.with_item(object: @wish, user: @donor) { 'row' } }
      end
    end

    buttons = page.all('.rz-menu-anchor > button[popovertarget]', visible: :all)
    anchors = buttons.pluck('popovertarget')
    assert_equal 2, anchors.uniq.size
  end
end
