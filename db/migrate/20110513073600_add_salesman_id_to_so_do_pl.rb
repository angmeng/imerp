class AddSalesmanIdToSoDoPl < ActiveRecord::Migration
  def self.up
    add_column :delivery_orders, :salesman_id,:integer
    add_index :delivery_orders, :salesman_id

    add_column :packing_lists, :salesman_id,:integer
    add_index :packing_lists, :salesman_id

    add_column :sales_orders, :salesman_id,:integer
    add_index :sales_orders, :salesman_id
  end

  def self.down
    remove_column :delivery_orders, :salesman_id
    remove_index :delivery_orders, :salesman_id

    remove_column :packing_lists, :salesman_id
    remove_index :packing_lists, :salesman_id

    remove_column :sales_orders, :salesman_id
    remove_index :sales_orders, :salesman_id
  end


  end
