# frozen_string_literal: true

# In-app notification for a user (target) about a wish or a discussion post (notifiable),
# caused by another user (notifier). `key` selects the text in notification.targets.*.
# Stored in the `notifications` table created by the former activity_notification gem.
class Notification < ApplicationRecord
  belongs_to :target, polymorphic: true
  belongs_to :notifiable, polymorphic: true, optional: true # may have been deleted since
  belongs_to :notifier, polymorphic: true, optional: true

  validates :key, presence: true

  scope :unopened_only, -> { where(opened_at: nil) }
  scope :opened_only, -> { where.not(opened_at: nil) }
  scope :latest_first, -> { order(created_at: :desc, id: :desc) }

  def opened? = opened_at.present?
  def unopened? = !opened?

  def open!
    update!(opened_at: Time.current) if unopened?
  end

  def self.open_all!
    unopened_only.update_all(opened_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
  end

  # the wish the notification is about (also for discussion posts)
  def wish
    notifiable.is_a?(Wish) ? notifiable : notifiable.try(:wish)
  end
end
