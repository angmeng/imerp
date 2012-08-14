class RemoveDiscountsOnInvoiceItems < ActiveRecord::Migration
  def self.up
   remove_column :invoice_items, :discounts
#    remove_index :invoice_items, :discounts

  end

  def self.down
  add_column :invoice_items, :discounts
#    add_index :invoice_items, :discounts

  end
end
