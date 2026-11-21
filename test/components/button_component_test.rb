# frozen_string_literal: true

require 'test_helper'

class ButtonComponentTest < ViewComponent::TestCase
  def test_plain_button
    render_inline(ButtonComponent.new('Uložit', type: :submit, class: 'save'))

    assert_selector 'button[type="submit"].rz-button.rz-button--filled.save', text: 'Uložit'
  end

  def test_link_for_get
    render_inline(ButtonComponent.new('Upravit', href: '/x/edit', variant: :tonal, class: 'edit'))

    assert_selector 'a.rz-button--tonal.edit[href="/x/edit"]', text: 'Upravit'
  end

  def test_form_for_other_methods_with_confirm
    confirm = { message: 'Opravdu?', yes: 'Ano', no: 'Ne' }
    render_inline(ButtonComponent.new('Smazat', href: '/x', method: :delete, confirm: confirm))

    form = page.find('form.rz-button-form[action="/x"]')
    assert_equal 'Opravdu?', form['data-rz-confirm']
    assert_equal 'Ano', form['data-confirm-yes']
    assert_selector 'input[name="_method"][value="delete"]', visible: :all
    assert_selector 'form button.rz-button', text: 'Smazat'
  end

  def test_turbo_form_uses_turbo_confirm
    render_inline(ButtonComponent.new('Smazat', href: '/x', method: :delete, confirm: 'Opravdu?',
                                                turbo: true))

    form = page.find('form')
    assert_equal 'true', form['data-turbo']
    assert_equal 'Opravdu?', form['data-turbo-confirm']
  end

  def test_icon_only_button_has_accessible_name
    render_inline(ButtonComponent.new(icon: 'check', aria_label: 'OK'))

    assert_selector 'button.rz-button--icon-only[aria-label="OK"] .rz-icon', text: 'check'
  end

  def test_unknown_variant
    assert_raises(ArgumentError) { ButtonComponent.new('x', variant: :fancy) }
  end
end
