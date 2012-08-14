class GoodsReceiveNoteItem < ActiveRecord::Base
  belongs_to :goods_receive_note
  belongs_to :product
  belongs_to :product_uom
  belongs_to :purchase_order_item
  belongs_to :stock_location

  attr_accessor :marked
  
  def full_deliver?
    quantity >= delivered_quantity
  end
end
