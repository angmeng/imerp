class CreateStockLocations < ActiveRecord::Migration
  def self.up
    create_table :stock_locations do |t|
      t.integer :product_id, :null => false
      t.integer :product_rack_id, :null => false
      
      t.timestamps
    end
    add_index :stock_locations, :product_id
    add_index :stock_locations, :product_rack_id
  end

  def self.down
    drop_table :stock_locations
  end
end
