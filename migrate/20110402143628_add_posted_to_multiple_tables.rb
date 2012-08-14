class AddPostedToMultipleTables < ActiveRecord::Migration
  def self.up
    add_column :delivery_orders, :posted, :boolean, :default => false
    add_column :goods_receive_notes, :posted, :boolean, :default => false
    add_column :delivery_order_items, :posted, :boolean, :default => false
    add_column :goods_receive_note_items, :posted, :boolean, :default => false

    add_index :delivery_orders, :posted
    add_index :goods_receive_notes, :posted
    add_index :delivery_order_items, :posted
    add_index :goods_receive_note_items, :posted
  end

  def self.down
    remove_index :delivery_orders, :posted
    remove_index :goods_receive_notes, :posted
    remove_index :delivery_order_items, :posted
    remove_index :goods_receive_note_items, :posted
    remove_column :delivery_orders, :posted
    remove_column :goods_receive_notes, :posted
    remove_column :delivery_order_items, :posted
    remove_column :goods_receive_note_items, :posted

  end
end
