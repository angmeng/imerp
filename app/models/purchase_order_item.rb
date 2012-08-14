class PurchaseOrderItem < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :purchase_requisition_item
  belongs_to :product
  belongs_to :product_uom
  has_many :goods_receive_note_items

  attr_accessor :marked
  #after_save :increase_product_quantity
  #after_destroy :decrease_product_quantity

  def total
    quantity * unit_price
  end

  def collected_quantity
    q = 0
    goods_receive_note_items.each do |i|
      q += i.delivered_quantity
    end
    q
  end

  def full_delivery?
    item_total = goods_receive_note_items.inject(0) {|sum, i| sum += i.delivered_quantity}
    item_total.to_i == quantity
  end
  def check_quantity

    GoodReceivedNoteIteam.first(:conditions => ["id = ? and delivered_quantity = ?", id, quantity])
    end

  end

