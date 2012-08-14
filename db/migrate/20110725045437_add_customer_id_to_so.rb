class AddCustomerIdToSo < ActiveRecord::Migration
  def self.up
     add_column :sales_orders, :customer_id,:integer
     add_index :sales_orders, :customer_id
  end

  def self.down
     remove_column :sales_orders, :customer_id,:integer
     remove_index :sales_orders, :customer_id

  end
end