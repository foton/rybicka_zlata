# frozen_string_literal: true

class AddOmniauthToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :provider, :string, index: true
    add_column :users, :uid, :string, index: true
  end
end
