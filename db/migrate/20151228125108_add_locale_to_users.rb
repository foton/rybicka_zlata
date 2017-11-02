# frozen_string_literal: true

class AddLocaleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :locale, :string, limit: 5, null: false, default: 'cs'
    add_column :users, :time_zone, :string, default: 'UTC', null: false
  end
end
