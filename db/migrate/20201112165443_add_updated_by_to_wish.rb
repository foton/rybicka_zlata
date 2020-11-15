class AddUpdatedByToWish < ActiveRecord::Migration[6.0]
  def change
    add_reference :wishes, :updated_by, foreign_key: { to_table: :users }
  end
end
