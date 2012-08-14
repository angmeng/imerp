class AddToInvoice < ActiveRecord::Migration
  def self.up
     add_column :invoices, :end_invoice_date, :date
  end

  def self.down
    remove_column :invoices, :end_invoice_date
  end
end
