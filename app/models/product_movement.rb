class ProductMovement < ActiveRecord::Base
  belongs_to :movement, :polymorphic => true
  belongs_to :product
  belongs_to :product_uom
  belongs_to :stock_location

  after_create :calculate_product_costing


  ADD_GRN_DESC = "Added into GRN"
  ADD_DO_DESC = "Added into Delivery Order"
  ADD_MIXED_PRODUCT_DESC = "Added into Mixed product"
  ADD_CUSTOMER_CN_DESC = "Added into Customer Credit Note"
  ADD_CUSTOMER_DN_DESC = "Added into Customer Debit Note"
  ADD_SUPPLIER_CN_DESC = "Added into Supplier Credit Note"
  ADD_SUPPLIER_DN_DESC = "Added into Supplier Debit Note"
  ADD_TRANSFER = "Added into Stock Transfer"
  ADD_ADJUSTMENT = "Added into Stock Adjustment"
  ADD_DISPOSAL = "Added into Stock Disposal"
  ADD_PACK = "Added into Pack"
  ADD_UNPACK = "Added into Un-Pack"
  ADD_MIXED_PACK = "Added Mixed into Pack"
  ADD_MIXED_UNPACK = "Added Mixed into Un-Pack"

  scope :mixed_product_movement, lambda { |prod_id| where(:product_id => prod_id, :mixed => true)  }
  scope :grn_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "GoodsReceiveNote") }
  scope :delivery_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "DeliveryOrder")  }
  scope :customer_dn_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "CustomerDebitNote") }
  scope :customer_cn_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "CustomerCreditNote") }
  scope :supplier_dn_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "SupplierDebitNote") }
  scope :supplier_cn_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "SupplierCreditNote") }
  scope :transfer_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "StockTransfer") }
  scope :adjustment_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "StockAdjustment") }
  scope :disposal_movement, lambda { |prod_id| where(:product_id => prod_id, :virtual_movement_type => "StockDisposal") }

  private

  def calculate_product_costing
    item = ProductUomItem.where("product_id = ? and product_uom_id = ?", product_id, product_uom_id).first
    if item
       case movement.class.to_s
        when "GoodsReceiveNote"
          ProductCosting.create!(:cost => cost, :quantity => quantity, :product_id => item.product_id, :product_uom_id => item.product_uom_id)
        when "DeliveryOrder"
          item.decrease(quantity)
        when "StockAdjustment"
          if quantity > 0
            item.increase(quantity)
          elsif quantity < 0
            item.decrease(quantity)
          end
        when "StockDisposal"
          item.decrease(quantity)
        when "StockTransfer"
          if quantity > 0
            item.increase(quantity)
          elsif quantity < 0
            item.decrease(quantity)
          end
        when "SupplierCreditNote"
          if quantity > 0
            item.decrease(quantity)
          elsif quantity < 0
            item.decrease(Engineer.negative(quantity))
          end
        when "SupplierDebitNote"
          if quantity > 0
            item.increase(quantity)
          elsif quantity < 0
            item.increase(Engineer.negative(quantity))
          end
        when "CustomerCreditNote"
          if quantity > 0
            item.increase(quantity)
          elsif quantity < 0
            item.increase(Engineer.negative(quantity))
          end
        when "CustomerDebitNote"
          if quantity > 0
            item.decrease(quantity)
          elsif quantity < 0
            item.decrease(Engineer.negative(quantity))
          end
        when "Pack"
          if quantity > 0
            item.increase(quantity)
          elsif quantity < 0
            item.decrease(Engineer.negative(quantity))
          end

        end
    end
  end
end
