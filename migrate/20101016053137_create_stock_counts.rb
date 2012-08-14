class CreateStockCounts < ActiveRecord::Migration
  def self.up
    create_table :stock_counts do |t|
      t.integer :stock_location_id, :null => false
      t.integer :product_uom_item_id, :null => false
      t.decimal :opening_balance, :precision => 12, :scale => 2, :default => 0.0
      t.decimal :quantity, :precision => 12, :scale => 2, :default => 0.0

      t.timestamps
    end
    
    add_index :stock_counts, :stock_location_id
    add_index :stock_counts, :product_uom_item_id
  end

  def self.down
    drop_table :stock_counts
  end
end
