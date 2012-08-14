class ChangeAllDecimalScale < ActiveRecord::Migration
  def self.up
    change_column :delivery_order_items, :unit_price, :decimal, :precision => 12, :scale => 2, :default => 0.00
    change_column :packing_list_items, :unit_price, :decimal, :precision => 12, :scale => 2, :default => 0.00
    change_column :purchase_requisition_items, :unit_price, :decimal, :precision => 12, :scale => 2, :default => 0.00
  end

  def self.down
  end
end
