# frozen_string_literal: true

class AddGroups < ActiveRecord::Migration
  def change
    create_table(:groups) do |t|
      t.string :name, null: false
      t.belongs_to :user, null: false, index: true
    end
    add_foreign_key :groups, :users, column: :user_id

    create_table(:connections_groups, id: false) do |t|
      t.belongs_to :group, null: true, index: true
      t.belongs_to :connection, null: true, index: true
    end
    add_foreign_key :connections_groups, :groups, column: :group_id
    add_foreign_key :connections_groups, :connections, column: :connection_id
  end
end
