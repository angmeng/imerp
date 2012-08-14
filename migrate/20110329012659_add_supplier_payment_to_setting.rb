class AddSupplierPaymentToSetting < ActiveRecord::Migration
   def self.up
    add_column :settings, :supplier_payment_code, :string, :default => "SP"
    add_column :settings, :supplier_payment_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :supplier_payment_code
    remove_column :settings, :supplier_payment_last_number
  end
end
