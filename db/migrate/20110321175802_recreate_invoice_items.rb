class ReCreateInvoiceItems < ActiveRecord::Migration
  def self.up
    drop_table :invoice_items
    create_table :invoice_items do |t|
      t.integer :invoice_id, :default => 0
      t.integer :delivery_order_id, :default => 0
      t.decimal :amount, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark

      t.timestamps
    end
    remove_index :invoice_items, :sales_order_item_id
    remove_index :invoice_items, :product_id
    remove_index :invoice_items, :product_uom_id
    add_index :invoice_items, :delivery_order_id
  end

  def self.down
    drop_table :invoice_items
  end
end
