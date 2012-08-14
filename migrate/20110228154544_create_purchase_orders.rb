class CreatePurchaseOrders < ActiveRecord::Migration
  def self.up
    create_table :purchase_orders do |t|
      t.date :purchase_order_date
      t.string :purchase_order_number, :limit => 20
      t.integer :supplier_id, :default => 0
      t.string :term, :limit => 45
      t.string :remark
      t.integer :purchase_requisition_id, :default => 0
      t.boolean :voided, :default => false
      t.boolean :settled, :default => false
      t.boolean :imported, :default => false
      t.timestamps
    end
    add_index :purchase_orders, :supplier_id
    add_index :purchase_orders, :purchase_requisition_id
    add_index :purchase_orders, :voided
    add_index :purchase_orders, :settled
  end

  def self.down
    drop_table :purchase_orders
  end
end
