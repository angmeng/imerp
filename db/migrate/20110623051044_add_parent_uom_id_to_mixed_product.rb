class AddParentUomIdToMixedProduct < ActiveRecord::Migration
  def self.up
     add_column :mixed_products, :parent_uom_id,:integer
     add_index :mixed_products, :parent_uom_id
  end

  def self.down
     remove_column :mixed_products, :parent_uom_id
     remove_index :mixed_products, :parent_uom_id
  end
end
