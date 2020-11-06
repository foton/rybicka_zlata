# frozen_string_literal: true

class AddBookedByIdToWishes < ActiveRecord::Migration[4.2]
  def change
    add_column :wishes, :booked_by_id, :integer, null: true, index: true
    add_foreign_key :wishes, :users, column: :booked_by_id, primary_key: :id
  end
end
