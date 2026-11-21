# frozen_string_literal: true

# M3 confirmation dialog (native <dialog>), one per page, driven by elements/rz_confirm.js:
# - Turbo forms: data-turbo-confirm (Turbo.config.forms.confirm)
# - plain forms: data-rz-confirm
# Optional data-confirm-yes / data-confirm-no on the form override the button labels.
class ConfirmDialogComponent < ApplicationComponent
  def call
    tag.dialog(id: 'confirm-dialog', class: 'rz-dialog',
               aria: { describedby: 'confirm-dialog-text' }) do
      tag.form(method: 'dialog', class: 'rz-dialog__form') do
        safe_join([tag.p(id: 'confirm-dialog-text', class: 'rz-dialog__text'), actions])
      end
    end
  end

  private

  def actions
    tag.div(class: 'rz-dialog__actions') do
      safe_join([dialog_button('cancel', 'no', t('confirm.no')),
                 dialog_button('confirm', 'yes', t('confirm.yes'))])
    end
  end

  def dialog_button(value, role, label)
    tag.button(label, value: value, class: 'rz-button rz-button--text',
                      data: { role: role, default_label: label })
  end
end
