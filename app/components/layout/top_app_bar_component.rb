# frozen_string_literal: true

module Layout
  # M3 small top app bar: menu toggle (narrow screens), brand, notifications,
  # theme and language switch.
  # Signed-out users get their navigation (sign up / sign in) right in the bar as #main_menu.
  class TopAppBarComponent < ApplicationComponent
    LOCALES = { cs: 'Čeština', en: 'English' }.freeze

    def initialize(user:, theme: nil, unopened_notifications_count: 0)
      super()
      @user = user
      @theme = theme
      @unopened_notifications_count = unopened_notifications_count.to_i
    end

    private

    attr_reader :user, :theme, :unopened_notifications_count

    def notifications_label
      label = t('notification.views.navigation')
      unopened_notifications_count.positive? ? "#{label} (#{unopened_notifications_count})" : label
    end

    def badge_text
      unopened_notifications_count > 99 ? '99+' : unopened_notifications_count.to_s
    end
  end
end
