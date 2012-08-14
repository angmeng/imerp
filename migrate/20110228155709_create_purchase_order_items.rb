class CreatePurchaseOrderItems < ActiveRecord::Migration
  def self.up
    create_table :purchase_order_items do |t|
      t.integer :purchase_order_id, :default => 0
      t.integer :purchase_requisition_item_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :quantity, :default => 0
      t.decimal :unit_price, :precision => 12, :scale => 2, :default => 0.00
      t.string :remark

      t.timestamps
    end
    add_index :purchase_order_items, :purchase_order_id
    add_index :purchase_order_items, :purchase_requisition_item_id
    add_index :purchase_order_items, :product_id
  end

  def self.down
    drop_table :purchase_order_items
  end
end
