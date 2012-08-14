class AddPostedToStockAdjustment < ActiveRecord::Migration
  def self.up
    add_column :stock_adjustments, :posted, :boolean, :default => false
    add_column :stock_adjustment_items, :posted, :boolean , :default => false

  end

  def self.down
     remove_column :stock_adjustments,:posted
     remove_column :stock_adjustment_items,:posted
  end
end
