class AddEnchancedDetailsToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :body_height, :string, default: '??'
    add_column :users, :body_weight, :string, default: '??'
    add_column :users, :tshirt_size, :string, default: '??'
    add_column :users, :trousers_waist_size, :string, default: '??'
    add_column :users, :trousers_leg_size, :string, default: '??'
    add_column :users, :shoes_size, :string, default: 'EU/UK/US??'
    add_column :users, :other_sizes_and_dimensions, :text, default: ''
    add_column :users, :likes, :text, default: ':-)'
    add_column :users, :dislikes, :text, default: ':-('
  end
end
