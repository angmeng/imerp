class CreateCustomerPayments < ActiveRecord::Migration
  def self.up
    create_table :customer_payments do |t|
      t.string :cust_payment_number, :limit => 20
      t.date :cust_payment_date
      t.string :remark
      t.boolean :voided, :default => false
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_payments
  end
end
