class PaymentMethod < ActiveRecord::Base
  has_many   :cust_payment_methods
  has_many   :customer_payments
   has_many   :supplier_payment_methods
  has_many   :supplier_payments

   scope :check_payment, where(:check => true)

  def self.selections
    result = all
    dummy = PaymentMethod.new
    dummy.id = 0
    dummy.payment_name = "None"
    result.insert(0, dummy)
    result.map {|c| [c.payment_name, c.id]}
  end
end
