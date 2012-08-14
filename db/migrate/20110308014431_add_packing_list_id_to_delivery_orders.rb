class AddPackingListIdToDeliveryOrders < ActiveRecord::Migration
   def self.up
    add_column :delivery_orders, :packing_list_id, :integer
  end

  def self.down
     remove_column :delivery_orders, :packing_list_id, :integer
  end
end
