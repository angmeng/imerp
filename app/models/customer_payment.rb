class CustomerPayment < ActiveRecord::Base
 
  has_many   :customer_payment_items
  belongs_to :customer
  belongs_to :payment_method

  before_create :generate_cust_payment_number
  attr_reader :invoice_tokens
  scope :unsettled, where(:settled => false)
  
 def status
     
      if settled?
        "<em style='color:green'>Completed</em>"
      else
        "<em style='color:blue'>Processing</em>"
      end
  
  end

def void_status
if voided?
    "<em style='color:red'>Voided</em>"
 else
    "<em style='color:brown'>Unvoided</em>"
end
end

  def add_autocomplete_invoice(item)
     error_msg = ""
      item_ids = item[:invoice_tokens].split(",")
      item_ids.uniq.each do |i|
      found = Invoice.find(i.to_i) rescue nil
     if found.customer_id == customer_id
        if customer_payment_items.first(:conditions => ["invoice_id =?", found.id])
           error_msg << found.invoice_number + " already exist. <br/>"
        else
          customer_payment_items.create!(:invoice_id => i.to_i) if found
        end
     else
        error_msg << found.invoice_number + " not belonging to customer of payment.<br>"
     end
      end
   error_msg
   end

   def add_invoice(item)
     error_msg = ""
    item.each do |invoice_id, content|
      if content[:selected].to_i == 1
        if customer_payment_items.first(:conditions => ["invoice_id = ?", invoice_id])
          error_msg << Invoice.find(invoice_id).invoice_number + " already exist.<br/>"
        else
          i = customer_payment_items.new
          i.invoice_id = invoice_id.to_i
          i.amount = i.invoice.total_amount
          i.save!
        end
      end
    end
    error_msg
  end

  def check_payment(customer_payment)
    found = PaymentMethod.find(customer_payment[:payment_method_id])
    if found.check
       update_attributes(customer_payment)
    else
      
    end
  end

 def update_items(item)
   error_msg=""
    item.each do |item_id, content|
     unless content[:paid_amount].index(/[abcdefghijklmnopqrstuvwxyz]/) or content[:paid_amount].blank?
     i = customer_payment_items.find(item_id.to_i)
     balance = i.invoice.total_amount - i.total_paid_amount
     i.remark = content[:remark]
     i.save!
     if content[:paid_amount].to_f  > balance + i.paid_amount
         error_msg << "paid amount exceed"
     else
        i.paid_amount = content[:paid_amount].to_i
        i.save!
    end
  end
   end
  error_msg
end

def remove_item(item)
   error_msg=""
   item.each do |inv_id, content|
    if content[:selected].to_i == 1
      i = customer_payment_items.find(inv_id)
      invoice = Invoice.find(i.invoice_id)
        unless invoice.payment_paid?
         i.destroy
        else
          error_msg << invoice.invoice_number + " already sattled and unsuccessfully delete"

       end
    end
  end
   error_msg
 end

 def verify_for_destroy
    self.voided = true
    save!
  end

 def payment_paid
   if posted?
     return false  
   else
      customer_payment_items.each do |i|
        inv = i.invoice
        total = 0.00
        inv.customer_payment_items.each do |payment|
          total += payment.paid_amount
        end

        if total == inv.total_amount
          inv.payment_paid = true
          inv.save!
        end
       end
    self.posted = true
     save!
       
    end
  end

  def check_customer(customer_payment)

    if customer_payment_items.any?
    if customer_id == customer_payment[:customer_id].to_i
      update_attributes(customer_payment)
      return true
    else
      return false
    end
  else
    update_attributes(customer_payment)
    return true
  end
end
def removed_payment_item(item)
    item.each do |item_id, content|
      if content[:selected]
        i = customer_payment_items.find(item_id)
        i.destroy
      end
    end
 end

def check_settle
      error_count = 0
      if self.payment_method_id.nil?
        error_count += 1
      end
      if customer_payment_items.any?
      customer_payment_items.each do |i|
           if i.paid_amount == 0 
             error_count += 1
           end
         end
      else
        error_count += 1
      end
      if error_count == 0
        self.settled = true
        save!
        return true
      else
        return false
      end

end
def customer_payment(customer_payment)
    found = PaymentMethod.find(customer_payment[:payment_method_id])

          if found.check
             self. cheque_number = (customer_payment[:cpm_number])
             self. bank = (customer_payment[:bank])
             self.cheque_date = (customer_payment[:cpm_date])
             self.payment_method_id = (customer_payment[:payment_method_id])
             self.cust_payment_date = (customer_payment[:cust_payment_date])
             self.remark = (customer_payment[:remark])
             save!
          else
             self. cheque_number = nil
             self. bank = nil
             self.cheque_date = nil
             self.payment_method_id = (customer_payment[:payment_method_id])
             self.cust_payment_date = (customer_payment[:cust_payment_date])
             self.remark = (customer_payment[:remark])
             save!
          end

        end

  private

  def generate_cust_payment_number
    setting = Setting.first
    setting.customer_payment_last_number += 1
    setting.save!
    self.cust_payment_number = setting.customer_payment_code + setting.customer_payment_last_number.to_s
  end

end
