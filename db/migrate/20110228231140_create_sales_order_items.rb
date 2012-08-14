class CreateSalesOrderItems < ActiveRecord::Migration
  def self.up
    create_table :sales_order_items do |t|
      t.integer :sales_order_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :product_uom_id, :default => 0
      t.integer :customer_id, :default => 0
      t.integer :quantity, :default => 0
      t.decimal :unit_price, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark
      t.boolean :confirmed, :default => false
      t.integer :invoice_id, :default => 0

      t.timestamps
    end
    add_index :sales_order_items, :sales_order_id
    add_index :sales_order_items, :product_id
    add_index :sales_order_items, :product_uom_id
    add_index :sales_order_items, :customer_id
    add_index :sales_order_items, :confirmed
    add_index :sales_order_items, :packing_list_id
  end

  def self.down
    drop_table :sales_order_items
  end
end
