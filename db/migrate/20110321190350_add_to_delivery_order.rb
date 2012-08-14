class AddToDeliveryOrder < ActiveRecord::Migration
  def self.up
    add_column :delivery_orders, :starred, :boolean, :default => false
  end

  def self.down
    remove_column :delivery_orders, :starred
  end
end
