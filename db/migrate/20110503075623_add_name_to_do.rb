class AddNameToDo < ActiveRecord::Migration
  def self.up
    add_column :delivery_orders, :name, :string
    add_index :delivery_orders, :name

  end

  def self.down
    remove_column :delivery_orders, :name
    remove_index :delivery_orders, :name

  end
end
