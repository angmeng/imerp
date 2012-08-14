class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.date :invoice_date
      t.string :invoice_number, :limit => 20
      t.integer :customer_id, :default => 0
      t.string :term, :limit => 45
      t.string :remark
      t.integer :sales_order_id, :default => 0
      t.boolean :voided, :default => false
      t.boolean :settled, :default => false
      t.boolean :imported, :default => false

      t.timestamps
    end
    add_index :invoices, :customer_id
    add_index :invoices, :sales_order_id
    add_index :invoices, :voided
    add_index :invoices, :settled
    add_index :invoices, :imported
  end

  def self.down
    drop_table :invoices
  end
end
