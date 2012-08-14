class CustomerPaymentItem < ActiveRecord::Base
   belongs_to :customer_payment
   belongs_to :invoice

  def total_amount
    amount
  end
 def total_paid_amount
    paid_items = CustomerPaymentItem.where("invoice_id = ?", invoice_id).all
    paid_items.inject(0) {|sum, item| sum += item.paid_amount }
  end
end
