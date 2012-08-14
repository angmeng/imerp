class AddFixedCostToProductUomItems < ActiveRecord::Migration
  def self.up
    add_column :product_uom_items, :fixed_cost, :decimal, :precision => 12, :scale => 3, :default => 0.000
    add_column :product_uom_items, :minimum_selling_price, :decimal, :precision => 12, :scale => 3, :default => 0.000
    add_column :product_uom_items, :maximum_purchase_price, :decimal, :precision => 12, :scale => 3, :default => 0.000
  end

  def self.down
    remove_column :product_uom_items, :maximum_purchase_price
    remove_column :product_uom_items, :minimum_selling_price
    remove_column :product_uom_items, :fixed_cost
  end
end
