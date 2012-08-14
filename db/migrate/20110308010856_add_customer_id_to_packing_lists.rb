class AddCustomerIdToPackingLists < ActiveRecord::Migration
  def self.up
    add_column :packing_lists, :customer_id, :integer
  end

  def self.down
    remove_column :packing_lists, :customer_id, :integer
  end
end



