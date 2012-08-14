class AddToStockAdjustmentItem < ActiveRecord::Migration
  def self.up
     add_column :stock_adjustment_items, :product_rack_id, :integer
  end

  def self.down
     remove_column :stock_adjustment_items,:product_rack_id
  end
end
