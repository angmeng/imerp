class AddSaleOrder < ActiveRecord::Migration
  def self.up
    add_column :sales_order_items, :packing_list_id, :integer, :default => 0
  end

  def self.down
     remove_column :sales_order_items, :packing_list_id
  end
end
