class CreateDeliveryOrderItems < ActiveRecord::Migration
  def self.up
    create_table :delivery_order_items do |t|
      t.integer :delivery_order_id, :null => false
      t.integer :product_id, :null => false
      t.integer :product_uom_id, :null => false
      t.integer :quantity, :null => false
      t.decimal :unit_price, :null => false
      t.integer :delivered_quantity, :default => 0
      t.string :remark
      t.integer :stock_location_id, :null => false
      t.boolean :settled, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_order_items
  end
end
