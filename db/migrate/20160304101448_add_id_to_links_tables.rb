# frozen_string_literal: true

class AddIdToLinksTables < ActiveRecord::Migration[4.2]
  def change
    add_column :donee_links, :id, :primary_key
    add_column :donor_links, :id, :primary_key
  end
end
