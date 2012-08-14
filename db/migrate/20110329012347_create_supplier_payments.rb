class CreateSupplierPayments < ActiveRecord::Migration
  def self.up
    create_table :supplier_payments do |t|
      t.string :supplier_payment_number, :limit => 20
      t.date :supplier_payment_date
      t.string :remark
      t.boolean :voided, :default => false
      t.integer :supplier_id

      t.timestamps
    end
  end

  def self.down
    drop_table :supplier_payments
  end
end
