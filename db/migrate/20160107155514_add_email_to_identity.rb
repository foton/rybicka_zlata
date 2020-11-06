# frozen_string_literal: true

class AddEmailToIdentity < ActiveRecord::Migration[4.2]
  def change
    add_column :identities, :email, :string
  end
end
