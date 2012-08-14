class AddProductIdAndProductUomIdToMultipleProduct < ActiveRecord::Migration
  def self.up
    add_column :product_pricings, :product_id,:integer
    add_index :product_pricings, :product_id
    add_column :stock_counts, :product_id,:integer
    add_index :stock_counts, :product_id
   

    add_column :product_pricings, :product_uom_id,:integer
    add_index :product_pricings, :product_uom_id
    add_column :stock_counts, :product_uom_id,:integer
    add_index :stock_counts, :product_uom_id
   
  end

  def self.down
    remove_column :product_pricings, :product_id,:integer
    remove_index :product_pricings, :product_id
    remove_column :stock_counts, :product_id,:integer
    remove_index :stock_counts, :product_id
    

    remove_column :product_pricings, :product_uom_id,:integer
    remove_index :product_pricings, :product_uom_id
    remove_column :stock_counts, :product_uom_id,:integer
    remove_index :stock_counts, :product_uom_id
   
  end
end