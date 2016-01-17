class AddTableFriendships < ActiveRecord::Migration
  def change
  	 create_table(:friendships) do |t|
      t.string :name, null: false
      t.string :email, null: false, index: true
      #cannot use t.reference :user
      #references to User (from_user_id) know many Friendships, which may or may not be User (to_user_id) of App
      t.belongs_to :friend, null: true, index: true  
      t.belongs_to :owner, null: true, index: true
    end   
    add_foreign_key :friendships, :users, column: :owner_id
    add_foreign_key :friendships, :users, column: :friend_id
  end
end
