class DeliveryOrderItem < ActiveRecord::Base
   belongs_to :delivery_order
   belongs_to :packing_list_item
   belongs_to :product_uom
   belongs_to :product
   belongs_to :stock_location

  attr_accessor :marked

  def full_deliver?
    quantity >= delivered_quantity
  end


  def total_amount
    price = delivered_quantity * unit_price
    discs = discounts.split("/")
       discs.each do |disc|
       price = price - (price * (disc.to_i) / 100)
       end
       price
  end

  def total_after_discount
    price =  unit_price
    discs = discounts.split("/")
       discs.each do |disc|
       price = price - (price * (disc.to_i) / 100)
       end
       price
  end

  

 def price
    sell_price = 0.0
      if product_uom_id == 0
        sell_price = 0.00
      else
        found_deli = delivery_order
        found_cust = Customer.first(:conditions => ["id = ?", found_deli.customer_id])
        pricing = ProductPricing.first(:conditions => ["price_level_id = ? and product_id = ? and product_uom_id = ?", found_cust.price_level_id, product_id, product_uom_id])

      if pricing
          sell_price = pricing.selling_price
        else
          sell_price = 0.00
        end
      end
    sell_price
  end
end


