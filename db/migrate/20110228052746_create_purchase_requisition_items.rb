class CreatePurchaseRequisitionItems < ActiveRecord::Migration
  def self.up
    create_table :purchase_requisition_items do |t|
      t.integer :purchase_requisition_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :supplier_id, :default => 0
      t.integer :quantity, :default => 0
      t.decimal :unit_price, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark
      t.boolean :confirmed, :default => false
      t.integer :purchase_order_id, :default => 0

      t.timestamps
    end
    add_index :purchase_requisition_items, :purchase_requisition_id
    add_index :purchase_requisition_items, :product_id
    add_index :purchase_requisition_items, :supplier_id
    add_index :purchase_requisition_items, :confirmed
    add_index :purchase_requisition_items, :purchase_order_id
  end

  def self.down
    drop_table :purchase_requisition_items
  end
end
