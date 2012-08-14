class AddToCustomerPaymentItem < ActiveRecord::Migration
   def self.up
      add_column :customer_payment_items, :paid_amount, :decimal, :precision => 12, :scale => 2, :default => 0.00
  end

  def self.down
    remove_column :customer_payment_items, :paid_amount
  end
end
