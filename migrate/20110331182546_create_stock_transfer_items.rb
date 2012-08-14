class CreateStockTransferItems < ActiveRecord::Migration
  def self.up
    create_table :stock_transfer_items do |t|
    t.integer :stock_transfer_id, :default => 0
    t.integer :product_id, :default => 0
    t.integer :from_product_rack_id, :default => 0
    t.integer :to_product_rack_id, :default => 0
    t.integer :quantity, :default => 0
    t.string  :description

      t.timestamps
    end

    add_index :stock_transfer_items, :stock_transfer_id
    add_index :stock_transfer_items, :product_id
    add_index :stock_transfer_items, :from_product_rack_id
    add_index :stock_transfer_items, :to_product_rack_id
  end

  def self.down
    drop_table :stock_transfer_items
  end
end
