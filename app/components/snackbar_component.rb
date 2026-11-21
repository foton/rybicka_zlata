# frozen_string_literal: true

# M3 snackbars for flash messages, rendered into <rz-snackbar id="snackbar">.
# Notices auto-hide (timer pauses on hover/focus); alerts and errors stay until dismissed.
# More can arrive later: Turbo Stream `append "snackbar"` with ItemComponent, or JS
# document.querySelector('#snackbar').show('Text', { kind: 'notice' }).
class SnackbarComponent < ApplicationComponent
  AUTOHIDE_MS = 10_000
  KINDS = { 'notice' => :notice, 'success' => :notice,
            'alert' => :error, 'error' => :error, 'warning' => :error }.freeze

  Message = Data.define(:kind, :text) do
    def autohide? = kind == :notice
  end

  def self.messages_from(flash)
    flash.to_hash.filter_map do |type, text|
      next if text.blank? || !text.is_a?(String)

      Message.new(kind: KINDS.fetch(type.to_s, :notice), text: text)
    end
  end

  def initialize(flash:)
    super()
    @messages = self.class.messages_from(flash)
  end

  attr_reader :messages
end
