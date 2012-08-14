class ChangeProductRackToStoreLocations < ActiveRecord::Migration
  def self.up
    rename_column(:stock_adjustment_items, :product_rack_id, :stock_location_id)
    rename_column(:stock_transfer_items, :from_product_rack_id, :from_stock_location_id)
    rename_column(:stock_transfer_items, :to_product_rack_id, :to_stock_location_id)

  end

  def self.down
  end
end
