class ProductVirtualMovement < ActiveRecord::Base
  belongs_to :virtual_movement, :polymorphic => true
  belongs_to :product
  belongs_to :product_uom
  belongs_to :stock_location

  ADD_PO_DESC = "Added into Purchase Order"
  ADD_PACKING_DESC = "Added into Packing list"
  ADD_MIXED_PRODUCT_PO_DESC = "Added into Purchase Order by Mixed product"
  ADD_MIXED_PRODUCT_PACKING_DESC = "Added into Packing Order by Mixed product"

  scope :mixed_purchase_order_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "PurchaseOrder", :mixed => true)  }
  scope :normal_purchase_order_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "PurchaseOrder", :mixed => false) }
  scope :mixed_packing_list_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "PackingList", :mixed => true)  }
  scope :normal_packing_list_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "PackingList", :mixed => false) }

end
