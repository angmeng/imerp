class SalesOrderItem < ActiveRecord::Base
  belongs_to :sales_order

  belongs_to :product
  belongs_to :product_uom
  has_one    :packing_list_item

  def total
    unit_price * quantity
  end

  def status
    confirmed? ? "<em style='color:green'>Confirmed</em>" : "<em style='color:blue'>Keep In view</em>"
  end

  def price
    sell_price = 0.0
      if product_uom_id == 0
        sell_price = 0.00
      else
        found_cust = sales_order.customer
        pricing = ProductPricing.first(:conditions => ["price_level_id = ? and product_id = ? and product_uom_id = ?", found_cust.price_level_id, product_id, product_uom_id])

      if pricing
          sell_price = pricing.selling_price
        else
          sell_price = 0.00
        end
      end
    sell_price
  end

# def discount
#      discs = sales_order_item.discounts.split("/")
#      amt = sales_order_item.total
#      discs.each do |disc|
#        amt = amt - (amt * disc / 100)
#      end
#  end


 def total_after_disc
   discs = discounts.split("/")
    price = total
   discs.each do |disc|
     price = price - (price * (disc.to_i) / 100)
   end
   price
 end


end