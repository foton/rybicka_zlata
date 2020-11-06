# frozen_string_literal: true

class SpeedIndexFixes < ActiveRecord::Migration[4.2]
  def change
    add_index :identities, :email
    add_foreign_key :identities, :users, column: :user_id
  end
end
