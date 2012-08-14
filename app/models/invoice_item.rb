class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :delivery_order



  attr_accessor :marked
  #after_save :increase_product_quantity
  #after_destroy :decrease_product_quantity

  
  def total
    amount
  end

  def total_amount
    amount
  end

end
