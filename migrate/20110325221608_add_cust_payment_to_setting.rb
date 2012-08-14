class AddCustPaymentToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :customer_payment_code, :string, :default => "CP"
    add_column :settings, :customer_payment_last_number, :integer, :default => 10000
  end

  def self.down
    remove_column :settings, :customer_payment_code
    remove_column :settings, :customer_payment_last_number
  end
end
