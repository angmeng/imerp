class CreatePackItems < ActiveRecord::Migration
  def self.up
    create_table :pack_items do |t|
      t.integer :pack_id, :limit => 20
      t.integer :product_id, :limit => 20
      t.integer :product_uom_id, :limit => 20
      t.integer :stock_location_id, :limit => 20
      t.integer :quantity, :limit => 20
      t.decimal :cost, :precision => 12, :scale => 3, :default => 0.000

      t.timestamps
    end
    add_index :pack_items, :pack_id
    add_index :pack_items, :product_id
    add_index :pack_items, :product_uom_id
    add_index :pack_items, :stock_location_id
  end

  def self.down
    drop_table :pack_items
  end
end
