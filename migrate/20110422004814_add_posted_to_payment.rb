class AddPostedToPayment < ActiveRecord::Migration
  def self.up
    add_column :customer_payments, :posted,:boolean, :default => false
    add_column :supplier_payments, :posted,:boolean, :default => false
    add_index :customer_payments, :posted
    add_index :supplier_payments, :posted

  end

  def self.down
    remove_column :invoices, :posted
    remove_column :invoices, :posted
    remove_index :invoices, :posted
    remove_index :invoices, :posted

  end
end
