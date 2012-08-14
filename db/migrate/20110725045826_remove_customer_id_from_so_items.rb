class RemoveCustomerIdFromSoItems < ActiveRecord::Migration
  def self.up
   remove_column :sales_order_items, :customer_id
#    remove_index :sales_order_items, :customer_id

  end

  def self.down
  add_column :sales_order_items, :customer_id
#    add_index :sales_order_items, :customer_id

  end
end
