class AddDiscountsToSoPlDoInvoiceItems < ActiveRecord::Migration
  def self.up
    add_column :sales_order_items, :discounts,:string,  :limit => 45
     add_index :sales_order_items, :discounts
     add_column :packing_list_items, :discounts,:string, :limit => 45
     add_index :packing_list_items, :discounts
     add_column :delivery_order_items, :discounts,:string, :limit => 45
     add_index :delivery_order_items, :discounts
     add_column :invoice_items, :discounts,:boolean, :limit => 45
     add_index :invoice_items, :discounts

  end

  def self.down
    remove_column :sales_order_items, :discounts
    remove_index :sales_order_items, :discounts
     remove_column :packing_list_items, :discounts
    remove_index :packing_list_items, :discounts
     remove_column :delivery_order_items, :discounts
    remove_index :delivery_order_items, :discounts
     remove_column :invoice_items, :discounts
    remove_index :invoice_items, :discounts

  end
end
