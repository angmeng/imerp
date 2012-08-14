class AddMinUomToProductUom < ActiveRecord::Migration
 def self.up
    add_column :product_uoms, :min_uom,:boolean, :default => false
     add_index :product_uoms, :min_uom

  end

  def self.down
    remove_column :product_uoms, :min_uom
    remove_index :product_uoms, :min_uom

  end
end
