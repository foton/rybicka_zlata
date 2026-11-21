# frozen_string_literal: true

require 'test_helper'

class SnackbarComponentTest < ViewComponent::TestCase
  def test_renders_notice_with_autohide
    render_inline(SnackbarComponent.new(flash: { 'notice' => 'Uloženo.' }))

    item = page.find('rz-snackbar#snackbar .rz-snackbar__item--notice')
    assert_equal 'status', item['role']
    assert_equal SnackbarComponent::AUTOHIDE_MS.to_s, item['data-autohide']
    assert_text 'Uloženo.'
  end

  def test_alert_is_persistent_and_announced
    render_inline(SnackbarComponent.new(flash: { 'alert' => 'Chyba!' }))

    item = page.find('.rz-snackbar__item--error')
    assert_equal 'alert', item['role']
    assert_nil item['data-autohide']
  end

  def test_skips_non_string_flash_values
    render_inline(SnackbarComponent.new(flash: { 'timedout' => true, 'notice' => '' }))

    assert_selector 'rz-snackbar#snackbar'
    assert_no_selector '.rz-snackbar__item'
  end
end
