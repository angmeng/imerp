class CreateDeliveryOrders < ActiveRecord::Migration
  def self.up
    create_table :delivery_orders do |t|
      t.date :delivery_order_date
      t.string :delivery_order_number, :limit => 20
      t.string :purchase_order_number, :limit => 20
      t.string :invoice_number, :limit => 20
      t.string :serial_number, :limit => 20
      t.string :remark
      t.boolean :voided, :default => false
      t.boolean :settled, :default => false


      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_orders
  end
end
