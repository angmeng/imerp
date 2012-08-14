class AddCustomerIdToDeliveryOrders < ActiveRecord::Migration
   def self.up
    add_column :delivery_orders, :customer_id, :integer
  end

  def self.down
     remove_column :delivery_orders, :customer_id, :integer
  end

end
