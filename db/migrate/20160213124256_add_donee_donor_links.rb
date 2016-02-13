class AddDoneeDonorLinks < ActiveRecord::Migration
  def change
 	  create_table(:donee_links, id: false) do |t|
      t.belongs_to :wish, null: false, index: true  
      t.belongs_to :connection, null: false, index: true
    end   
    
    add_foreign_key :donee_links, :wishes
    add_foreign_key :donee_links, :connections
    add_index :donee_links, [:wish_id, :connection_id], {name: "donee_wish_conn_index", unique: true}
         


 	  create_table(:donor_links, id: false) do |t|
      t.belongs_to :wish, null: false, index: true  
      t.belongs_to :connection, null: false, index: true
      t.integer    :role, null: false, default: DonorLink::ROLE_AS_POTENCIAL_DONOR, index: true
    end   
    
    add_foreign_key :donor_links, :wishes
    add_foreign_key :donor_links, :connections
    add_index :donor_links, [:wish_id, :connection_id], {name: "donor_wish_conn_index", unique: true}
  end
end
