class PackingListItem < ActiveRecord::Base
  belongs_to :packing_list
  belongs_to :sales_order_item
  belongs_to :product
  belongs_to :product_uom
  has_many :delivery_order_items
 

  attr_accessor :marked
  #after_save :increase_product_quantity
  #after_destroy :decrease_product_quantity

  def total
    quantity * unit_price
  end

  def collected_quantity
    q = 0
    delivery_order_items.each do |i|
      q += i.delivered_quantity
    end
    q
  end

  def full_delivery?
    item_total = delivery_order_items.inject(0) {|sum, i| sum += i.delivered_quantity}
    item_total.to_i == quantity
  end

end
