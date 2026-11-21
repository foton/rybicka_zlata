# frozen_string_literal: true

require 'test_helper'

class RzFormBuilderTest < ActionView::TestCase
  def setup
    @connection = Connection.new(name: 'Dad', email: '')
  end

  def test_outlined_text_field_with_label_after_input
    html = build { |f| f.text_field :name, label: 'Přezdívka' }

    assert_fragment html, 'div.rz-text-field.field > input#connection_name.rz-text-field__input'
    assert_fragment html, 'input#connection_name[placeholder=" "]'
    assert_fragment html, 'input + label.rz-text-field__label[for="connection_name"]',
                    text: 'Přezdívka'
  end

  def test_default_label_is_translated_attribute
    html = build { |f| f.email_field :email }

    assert_fragment html, 'label[for="connection_email"]',
                    text: Connection.human_attribute_name(:email)
  end

  def test_error_state_and_message
    @connection.errors.add(:email, 'je povinná položka')
    html = build { |f| f.email_field :email, supporting_text: 'nápověda' }

    assert_fragment html, 'div.rz-text-field--error input[aria-invalid="true"]'
    assert_fragment html, 'input[aria-describedby="connection_email_supporting"]'
    assert_fragment html, 'div#connection_email_supporting.rz-field__supporting',
                    text: 'je povinná položka'
  end

  def test_forced_error_state_without_validation_error
    html = build { |f| f.password_field :name, error: true }

    assert_fragment html, 'div.rz-text-field--error input[aria-invalid="true"]'
    assert_no_match(/rz-field__supporting/, html)
  end

  def test_password_field_has_hidden_show_toggle
    html = build { |f| f.password_field :name }

    assert_fragment html, 'div.rz-text-field--password input[type="password"]'
    assert_fragment html, 'button[type="button"][data-password-toggle][hidden][aria-pressed="false"]'
    assert_fragment html, 'button[aria-label="Zobrazit heslo"] .rz-icon', text: 'visibility'
  end

  def test_supporting_text
    html = build { |f| f.text_field :name, supporting_text: 'nápověda' }

    assert_fragment html, '.rz-field__supporting', text: 'nápověda'
  end

  def test_text_area_and_no_label
    html = build { |f| f.text_area :name, label: false, placeholder: 'Napište...' }

    assert_fragment html, 'div.rz-text-field--textarea.rz-text-field--no-label textarea'
    assert_fragment html, 'textarea[placeholder="Napište..."]'
    assert_no_match(/<label/, html)
  end

  def test_select_with_icon
    html = build { |f| f.select :name, %w[a b], {}, label: 'Jméno' }

    assert_fragment html, 'div.rz-text-field--select select.rz-text-field__input.rz-select__input'
    assert_fragment html, 'select + label', text: 'Jméno'
    assert_fragment html, '.rz-select__icon', text: 'arrow_drop_down'
  end

  def test_checkbox_and_switch_inside_their_labels
    html = build do |f|
      f.check_box(:name, label: 'Souhlas') + f.switch(:email, label: 'Zapamatovat')
    end

    assert_fragment html, 'div.rz-checkbox label.rz-checkbox__label input.rz-checkbox__input'
    assert_fragment html, 'div.rz-checkbox .rz-checkbox__text', text: 'Souhlas'
    assert_fragment html, 'div.rz-switch input[type="checkbox"][role="switch"].rz-switch__input'
    assert_fragment html, 'div.rz-switch .rz-switch__text', text: 'Zapamatovat'
  end

  def test_submit_is_m3_button
    html = build { |f| f.submit 'Uložit', class: 'save' }

    assert_fragment html, 'button[type="submit"].rz-button.rz-button--filled.save', text: 'Uložit'
  end

  private

  def build(&block)
    form_with(model: @connection, url: '/x', builder: RzFormBuilder) { |f| block.call(f) }
  end

  def assert_fragment(html, selector, **)
    assert_select Nokogiri::HTML5.fragment(html), selector, **
  end
end
