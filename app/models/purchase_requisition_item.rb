class PurchaseRequisitionItem < ActiveRecord::Base
  belongs_to :purchase_requisition
  belongs_to :supplier
  belongs_to :product
  belongs_to :product_uom
  has_one    :purchase_order_item

  def total
    unit_price * quantity
  end

  def status
    confirmed? ? "<em style='color:green'>Confirmed</em>" : "<em style='color:blue'>Keep In view</em>"
  end

  def product_name
    product.code_name if product
  end

  def product_name=(name)
    
  end
  

end
