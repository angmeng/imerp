class AddPamentPaidToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :payment_paid,:boolean, :default => false
    add_index :invoices, :payment_paid
  end

  def self.down
    remove_index :invoices, :payment_paid
    remove_column :invoices, :payment_paid
  end
end