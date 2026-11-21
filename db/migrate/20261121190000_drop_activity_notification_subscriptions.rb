# frozen_string_literal: true

# The `subscriptions` table belonged to the activity_notification gem (subscriptions were
# disabled and the gem has been replaced by the app's own Notification model).
# Reversible: rollback recreates the (empty) table with its indexes.
class DropActivityNotificationSubscriptions < ActiveRecord::Migration[8.1]
  def change # rubocop:disable Metrics/AbcSize, Metrics/MethodLength -- full table definition for rollback
    drop_table :subscriptions do |t|
      t.datetime :created_at, precision: nil, null: false
      t.string :key, null: false
      t.bigint :notifiable_id
      t.string :notifiable_type
      t.text :optional_targets
      t.datetime :subscribed_at, precision: nil
      t.datetime :subscribed_to_email_at, precision: nil
      t.boolean :subscribing, default: true, null: false
      t.boolean :subscribing_to_email, default: true, null: false
      t.bigint :target_id, null: false
      t.string :target_type, null: false
      t.datetime :unsubscribed_at, precision: nil
      t.datetime :unsubscribed_to_email_at, precision: nil
      t.datetime :updated_at, precision: nil, null: false
      t.index :key, name: 'index_subscriptions_on_key'
      t.index %i[notifiable_type notifiable_id], name: 'index_subscriptions_on_notifiable'
      t.index %i[target_type target_id key notifiable_type notifiable_id],
              name: 'index_subscriptions_uniqueness', unique: true
      t.index %i[target_type target_id], name: 'index_subscriptions_on_target_type_and_target_id'
    end
  end
end
