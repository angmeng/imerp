class CreateCustomerPaymentItems < ActiveRecord::Migration
  def self.up
    create_table :customer_payment_items do |t|
      t.integer :customer_payment_id, :default => 0
      t.integer :invoice_id, :default => 0
      t.decimal :amount, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_payment_items
  end
end
