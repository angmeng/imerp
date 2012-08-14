class AddToPurchaseOrders < ActiveRecord::Migration
  def self.up
     add_column :purchase_orders, :starred, :boolean, :default => false
  end

  def self.down
      remove_column :purchase_orders, :starred
  end
end
