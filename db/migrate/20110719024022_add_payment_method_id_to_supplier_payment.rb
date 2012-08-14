class AddPaymentMethodIdToSupplierPayment < ActiveRecord::Migration
 def self.up
    add_column :supplier_payments, :payment_method_id,:integer
     add_index :supplier_payments, :payment_method_id
  end

  def self.down
    remove_column :supplier_payments, :payment_method_id,:integer
     remove_index :supplier_payments, :payment_method_id
  end
end
