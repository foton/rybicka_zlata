# frozen_string_literal: true

require 'test_helper'

class ConfirmDialogComponentTest < ViewComponent::TestCase
  def test_renders_dialog_with_default_labels
    render_inline(ConfirmDialogComponent.new)

    dialog = page.find('dialog#confirm-dialog.rz-dialog', visible: :all)
    assert dialog.has_css?('form[method="dialog"] #confirm-dialog-text', visible: :all)
    assert dialog.has_css?('button[value="confirm"][data-role="yes"]', text: 'Ano', visible: :all)
    assert dialog.has_css?('button[value="cancel"][data-role="no"]', text: 'Ne', visible: :all)
  end
end
