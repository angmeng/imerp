class AddSattledToPayment < ActiveRecord::Migration
 def self.up
    add_column :customer_payments, :sattled,:boolean, :default => false
    add_column :supplier_payments, :sattled,:boolean, :default => false
    add_index :customer_payments, :sattled
    add_index :supplier_payments, :sattled
  end

  def self.down
    remove_column :invoices, :sattled
    remove_column :invoices, :sattled
    remove_index :invoices, :sattled
    remove_index :invoices, :sattled

  end
end
