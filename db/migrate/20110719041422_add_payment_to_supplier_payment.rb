class AddPaymentToSupplierPayment < ActiveRecord::Migration
   def self.up
    add_column :supplier_payments, :cheque_date,:date
    add_column :supplier_payments, :cheque_number,:string
    add_column :supplier_payments, :bank,:string

  end

  def self.down

    remove_column :supplier_payments, :cheque_date,:date
    remove_column :supplier_payments, :cheque_number,:string
    remove_column :supplier_payments, :bank,:string
  end
end
