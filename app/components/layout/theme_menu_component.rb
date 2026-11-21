# frozen_string_literal: true

module Layout
  # Light / dark / system theme switch in the top app bar (icon button + popover menu).
  # Items are plain links to StaticController#change_theme (works without JS);
  # elements/rz_theme.js switches instantly without a reload.
  class ThemeMenuComponent < ApplicationComponent
    CHOICES = %w[light dark system].freeze
    ICONS = { 'light' => 'light_mode', 'dark' => 'dark_mode', 'system' => 'brightness_auto' }.freeze

    # theme: 'light', 'dark' or nil (system)
    def initialize(theme:)
      super()
      @current = theme.presence || 'system'
    end

    private

    attr_reader :current

    def label
      t('rybickazlata.layout.theme.label')
    end

    def choice_label(choice)
      t("rybickazlata.layout.theme.#{choice}")
    end

    def selected?(choice)
      choice == current
    end
  end
end
