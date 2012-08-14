class CreateStockDisposalItems < ActiveRecord::Migration
  def self.up
    create_table :stock_disposal_items do |t|
    t.integer :stock_disposal_id, :default => 0
    t.integer :product_id, :default => 0
    t.integer :product_uom_id, :default => 0
    t.integer :stock_location_id, :default => 0
    t.integer :quantity, :default => 0
    t.string  :description
    t.boolean :posted, :default => false
    t.timestamps
    end

    add_index :stock_disposal_items, :stock_disposal_id
    add_index :stock_disposal_items, :product_id
    add_index :stock_disposal_items, :product_uom_id
    add_index :stock_disposal_items, :stock_location_id
  end

  def self.down
    drop_table :stock_disposal_items
  end
end
