class AddSalesOrderIdToPackingLists < ActiveRecord::Migration
  def self.up
    add_column :packing_lists, :sales_order_id, :integer
  end

  def self.down
     remove_column :packing_lists, :sales_order_id, :integer
  end

end
