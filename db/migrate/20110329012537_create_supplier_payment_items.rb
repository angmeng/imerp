class CreateSupplierPaymentItems < ActiveRecord::Migration
  def self.up
    create_table :supplier_payment_items do |t|
      t.integer :supplier_payment_id, :default => 0
      t.integer :purchase_order_id, :default => 0
      t.decimal :amount, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark
      t.decimal :paid_amount, :precision => 12, :scale => 2, :default => 0.00
      t.timestamps
    end
  end

  def self.down
    drop_table :supplier_payment_items
  end

end



