# frozen_string_literal: true

# Lets a model send notifications to groups of users (replaces activity_notification's
# acts_as_notifiable / notify).
#
#   notifies :donors, targets: ->(wish, key) { wish.donor_users - [wish.updated_by] }
#   wish.notify(:donors, key: 'wish.updated', notifier: user)
module Notifiable
  extend ActiveSupport::Concern

  included do
    class_attribute :notification_target_groups, instance_writer: false, default: {}
  end

  class_methods do
    def notifies(group, targets:)
      self.notification_target_groups = notification_target_groups.merge(group.to_sym => targets)
    end
  end

  def notification_targets(group, key = nil)
    resolver = notification_target_groups.fetch(group.to_sym) do
      raise ArgumentError, "#{self.class} has no notification group #{group.inspect}"
    end
    Array(resolver.call(self, key)).compact.uniq
  end

  # one notification for every target of the group; returns them
  def notify(group, key:, notifier: nil)
    notification_targets(group, key).map do |target|
      Notification.create!(target: target, notifiable: self, key: key, notifier: notifier)
    end
  end
end
