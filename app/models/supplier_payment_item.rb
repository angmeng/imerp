class SupplierPaymentItem < ActiveRecord::Base
  belongs_to :supplier_payment
  belongs_to :purchase_order

  def total_amount
    amount
  end

  def total_paid_amount
    paid_items = SupplierPaymentItem.where("purchase_order_id = ?", purchase_order_id).all
    paid_items.inject(0) {|sum, item| sum += item.paid_amount }
  end

end
