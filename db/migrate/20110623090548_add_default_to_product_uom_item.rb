class AddDefaultToProductUomItem < ActiveRecord::Migration
  def self.up
    add_column :product_uom_items, :default_uom,:boolean, :default => false
  end

  def self.down
    remove_column :product_uom_items, :default_uom
  end
end
