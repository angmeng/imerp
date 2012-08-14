class AddProductOumIdToStockAdjustmentTransfer < ActiveRecord::Migration
  def self.up
    add_column :stock_adjustment_items, :product_uom_id, :integer
    add_column :stock_transfer_items, :product_uom_id, :integer

    add_index :stock_adjustment_items, :product_uom_id
    add_index :stock_transfer_items, :product_uom_id
  end

  def self.down
    remove_column :stock_adjustment_items, :product_uom_id
    remove_column :stock_transfer_items,:product_uom_id

    remove_index  :stock_adjustment_items, :product_uom_id
    remove_index  :stock_transfer_items, :product_uom_id
  end
end
