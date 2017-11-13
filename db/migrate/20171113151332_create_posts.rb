class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.boolean :show_to_anybody, default: false
      t.references :author, references: :users, index: true
      t.references :wish
      t.timestamps
    end
  end
end
