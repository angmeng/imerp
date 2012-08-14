class AddNameToPayment < ActiveRecord::Migration
 def self.up
    add_column :invoices, :name, :string
    add_index :invoices, :name
    add_column :purchase_orders, :name, :string
    add_index :purchase_orders, :name
  end

  def self.down
    remove_column :invoices, :name
    remove_column :invoices, :name
    remove_index :purchase_orders, :name
    remove_index :purchase_orders, :name

  end
end
