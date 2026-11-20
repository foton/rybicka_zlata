# frozen_string_literal: true

# Adds the instance-level subscription fields required by activity_notification 2.6+.
class AddNotifiableToActivityNotificationSubscriptions < ActiveRecord::Migration[8.1]
  OLD_UNIQUE_INDEX_COLUMNS = %i[target_type target_id key].freeze
  UNIQUE_INDEX_COLUMNS = %i[target_type target_id key notifiable_type notifiable_id].freeze
  UNIQUE_INDEX_NAME = 'index_subscriptions_uniqueness'

  def up
    add_notifiable_reference
    remove_index :subscriptions, OLD_UNIQUE_INDEX_COLUMNS if old_unique_index_exists?
    add_unique_index unless new_unique_index_exists?
  end

  def down
    remove_index :subscriptions, name: UNIQUE_INDEX_NAME if new_unique_index_exists?
    add_index :subscriptions, OLD_UNIQUE_INDEX_COLUMNS, unique: true unless old_unique_index_exists?
    remove_reference :subscriptions, :notifiable, polymorphic: true, index: true
  end

  private

  def add_notifiable_reference
    return if notifiable_reference_exists?

    add_reference :subscriptions, :notifiable, polymorphic: true, index: true
  end

  def notifiable_reference_exists?
    column_exists?(:subscriptions, :notifiable_type) &&
      column_exists?(:subscriptions, :notifiable_id)
  end

  def add_unique_index
    add_index :subscriptions, UNIQUE_INDEX_COLUMNS, unique: true, name: UNIQUE_INDEX_NAME
  end

  def old_unique_index_exists?
    index_exists?(:subscriptions, OLD_UNIQUE_INDEX_COLUMNS, unique: true)
  end

  def new_unique_index_exists?
    index_exists?(:subscriptions, name: UNIQUE_INDEX_NAME)
  end
end
