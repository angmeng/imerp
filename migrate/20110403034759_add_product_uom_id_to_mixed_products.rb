class AddProductUomIdToMixedProducts < ActiveRecord::Migration
  def self.up
    add_column :mixed_products, :product_uom_id, :integer, :default => 0
    add_index :mixed_products, :product_uom_id
  end

  def self.down
    remove_index :mixed_products, :product_uom_id
    remove_column :mixed_products, :product_uom_id
  end
end
