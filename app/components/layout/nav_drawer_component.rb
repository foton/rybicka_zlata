# frozen_string_literal: true

module Layout
  # M3 navigation drawer (#main_menu) for signed-in users.
  # Wide screens: standard drawer, always visible. Narrow screens: modal drawer
  # using the native Popover API (opened by the menu button in the top app bar),
  # so it needs no JavaScript (light dismiss, Esc, top layer are built in).
  class NavDrawerComponent < ApplicationComponent
    def initialize(user:, current_path:, unopened_notifications_count: 0)
      super()
      @user = user
      @current_path = current_path
      @unopened_notifications_count = unopened_notifications_count.to_i
    end

    def items
      @items ||= wish_items + people_items + [profile_item, notifications_item]
    end

    private

    attr_reader :user, :current_path, :unopened_notifications_count

    def wish_items
      [
        item('wishes.from_donor.views.index.header', helpers.user_others_wishes_path(user),
             'redeem'),
        item('wishes.from_donee.views.index.header', helpers.user_my_wishes_path(user),
             'featured_seasonal_and_gifts')
      ]
    end

    def people_items
      [
        item('connections.views.header', helpers.user_connections_path(user), 'contacts'),
        item('groups.views.header', helpers.user_groups_path(user), 'groups')
      ]
    end

    def profile_item
      item('user.profile.my.header', helpers.my_profile_path, 'account_circle')
    end

    def notifications_item
      badge = unopened_notifications_count if unopened_notifications_count.positive?
      item('notification.views.navigation', helpers.user_notifications_path(user), 'notifications',
           badge:)
    end

    def item(label_key, path, icon, badge: nil)
      NavItem.new(label: t(label_key), path:, icon:, badge:)
    end

    def active_item
      @active_item ||= items.select { |i| i.active?(current_path) }.max_by { |i| i.path.length }
    end
  end
end
