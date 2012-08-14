class CreateStockAdjustmentItems < ActiveRecord::Migration
  def self.up
    create_table :stock_adjustment_items do |t|
      t.integer :stock_adjustment_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :quantity, :default => 0
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :stock_adjustment_items
  end
end
