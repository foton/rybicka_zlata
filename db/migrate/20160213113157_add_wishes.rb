# frozen_string_literal: true

class AddWishes < ActiveRecord::Migration[4.2]
  def change
    create_table(:wishes) do |t|
      t.string :title, null: false
      t.text    :description
      t.integer :state, null: false, default: Wish::STATE_AVAILABLE
      t.belongs_to :author, null: false, index: true

      t.timestamps
      t.datetime :updated_by_donee_at
    end
    add_foreign_key :wishes, :users, column: :author_id, primary_key: :id
  end
end
