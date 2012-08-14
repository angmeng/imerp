class AddPaymentMethodIdToCustomerPayment < ActiveRecord::Migration
  def self.up
    add_column :customer_payments, :payment_method_id,:integer
     add_index :customer_payments, :payment_method_id
  end

  def self.down
    remove_column :customer_payments, :payment_method_id,:integer
     remove_index :customer_payments, :payment_method_id
  end
end
