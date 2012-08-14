class AddPaymentToCustomerPayment < ActiveRecord::Migration
   def self.up
    add_column :customer_payments, :cheque_date,:date
    add_column :customer_payments, :cheque_number,:string
    add_column :customer_payments, :bank,:string

  end

  def self.down
   
    remove_column :customer_payments, :cheque_date,:date
    remove_column :customer_payments, :cheque_number,:string
    remove_column :customer_payments, :bank,:string
  end
end
