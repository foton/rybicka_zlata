# frozen_string_literal: true

class AddIdToLinksTables < ActiveRecord::Migration
  def change
    add_column :donee_links, :id, :primary_key
    add_column :donor_links, :id, :primary_key
  end
end
