class AddIdToStockLocationAndCount < ActiveRecord::Migration
  def self.up
     add_column :stock_locations, :product_location_id,:integer
     add_index :stock_locations, :product_location_id
      add_column :stock_counts, :product_rack_id,:integer
     add_index :stock_counts, :product_rack_id
      add_column :stock_counts, :product_location_id,:integer
     add_index :stock_counts, :product_location_id
  end

  def self.down
     remove_column :stock_locations, :product_location_id,:integer
     remove_index :stock_locations, :product_location_id
      remove_column :stock_counts, :product_rack_id,:integer
     remove_index :stock_counts, :product_rack_id
      remove_column :stock_counts, :product_location_id,:integer
     remove_index :stock_counts, :product_location_id
  end
end
