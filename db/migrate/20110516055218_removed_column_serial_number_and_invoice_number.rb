class RemovedColumnSerialNumberAndInvoiceNumber < ActiveRecord::Migration
  def self.up
    remove_column :delivery_orders, :serial_number
    remove_column :delivery_orders, :invoice_number

  end

  def self.down
    add_column :delivery_orders, :serial_number
    add_column :delivery_orders, :invoice_number

  end
end
