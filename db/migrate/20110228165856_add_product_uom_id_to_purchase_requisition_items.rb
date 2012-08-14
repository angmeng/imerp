class AddProductUomIdToPurchaseRequisitionItems < ActiveRecord::Migration
  def self.up
    add_column :purchase_requisition_items, :product_uom_id, :integer, :default => 0
    add_column :purchase_order_items, :product_uom_id, :integer, :default => 0
    add_index :purchase_requisition_items, :product_uom_id
    add_index :purchase_order_items, :product_uom_id
  end

  def self.down
    remove_column :purchase_requisition_items, :product_uom_id
  end
end
