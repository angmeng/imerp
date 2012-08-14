class CreatePackItemSubitems < ActiveRecord::Migration
  def self.up
    create_table :pack_item_subitems do |t|
      t.integer :pack_item_id, :limit => 20
      t.integer :product_id, :limit => 20
      t.integer :product_uom_id, :limit => 20
      t.integer :stock_location_id, :limit => 20
      t.integer :quantity, :limit => 20

      t.timestamps
    end
     add_index :pack_item_subitems, :pack_item_id
     add_index :pack_item_subitems, :product_id
     add_index :pack_item_subitems, :product_uom_id
     add_index :pack_item_subitems, :stock_location_id

  end

  def self.down
    drop_table :pack_item_subitems
  end
end
