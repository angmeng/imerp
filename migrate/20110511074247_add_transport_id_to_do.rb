class AddTransportIdToDo < ActiveRecord::Migration
   def self.up
    add_column :delivery_orders, :transport_id,:integer
    add_index :delivery_orders, :transport_id
  end

  def self.down
    remove_column :delivery_orders, :transport_id
    remove_index :delivery_orders, :transport_id
  end
end

