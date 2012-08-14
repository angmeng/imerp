class CreateInvoiceItems < ActiveRecord::Migration
  def self.up
    create_table :invoice_items do |t|
      t.integer :invoice_id, :default => 0
      t.integer :sales_order_item_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :product_uom_id, :default => 0
      t.integer :quantity, :default => 0
      t.decimal :unit_price, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark

      t.timestamps
    end
    add_index :invoice_items, :invoice_id
    add_index :invoice_items, :sales_order_item_id
    add_index :invoice_items, :product_id
    add_index :invoice_items, :product_uom_id
  end

  def self.down
    drop_table :invoice_items
  end
end
