class AddPaymentPaidToPurchaseOrder < ActiveRecord::Migration
   def self.up
    add_column :purchase_orders, :payment_paid,:boolean, :default => false
    add_index :purchase_orders, :payment_paid
  end

  def self.down
    remove_index :purchase_orders, :payment_paid
    remove_column :purchase_orders, :payment_paid
  end
end