class AddDelivery < ActiveRecord::Migration
  def self.up
     add_column :delivery_order_items, :packing_list_item_id, :integer, :default => 0

  end

  def self.down
    remove_column :delivery_order_items, :packing_list_item_id, :integer, :default => 0
  end
end
